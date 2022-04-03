//
//  LoginReactor.swift
//  Tooda
//
//  Created by 황재욱 on 2021/06/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift
import RxCocoa
import RxFlow
import FirebaseAnalytics
import Then

final class LoginReactor: Reactor, Stepper {
  
  // MARK: - Constants
  
  struct Dependency {
    let service: NetworkingProtocol
    @available(*, deprecated, message: "RxFlow로 대체될 예정이에요.")
    let coordinator: AppCoordinatorType
    let localPersistanceManager: LocalPersistanceManagerType
    let socialLoginService: SocialLoginServiceType
    let snackBarEventBus: Observable<SnackBarManager.SnackBarInfo>
  }
  
  enum Action {
    case login
  }
  
  enum Mutation {
    case setIsAuthorized(isAuthorized: Bool)
    case setSnackBarInfo(SnackBarManager.SnackBarInfo)
  }
  
  struct State: Then {
    var isAuthorized: Bool
    var snackBarInfo: SnackBarManager.SnackBarInfo?
  }
  
  // MARK: - Properties
  
  private let dependency: Dependency
  
  private let disposeBag = DisposeBag()
  
  let initialState: State = State(isAuthorized: false)
  
  // MARK: - Stepper
  var steps: PublishRelay<Step> = .init()
  
  // MARK: - Con(De)structor
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
}

// MARK: - mutate & reduce
extension LoginReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .login:
      return socialLoginMutation()
    }
  }
  
  private func socialLoginMutation() -> Observable<Mutation> {
    dependency.socialLoginService.signIn(type: .apple)
    
    return Observable.empty()
  }
  
  private func signInMutation(with token: String) -> Observable<Mutation> {
    return Observable<String>.just(token)
      .flatMap { [weak self] token -> Observable<Mutation> in
        guard let self = self else { return Observable.empty() }
        return self.dependency.service.request(
            AuthAPI.signUp(token: token)
          )
          .map(AppToken.self)
          .catchAndReturn(AppToken(accessToken: nil))
          .asObservable()
          .flatMap { [weak self] token -> Observable<Mutation> in
            guard let self = self else { return Observable.empty() }
            if token.accessToken == nil {
              return Observable.just(
                Mutation.setSnackBarInfo(.init(
                  title: "앗, 문제가 있네요. 다시 시도해보세요!",
                  type: .negative
                ))
              )
            } else {
              return Observable<Mutation>.concat([
                self.setAppToken(token: token),
                Observable<Mutation>.just(Mutation.setIsAuthorized(isAuthorized: true)),
                self.routeToHomeMutation()
              ])
            }
          }
      }
  }
  
  private func setAppToken(token: AppToken) -> Observable<Mutation> {
    dependency.localPersistanceManager.setObject(
      value: token,
      forKey: .appToken
    )
    
    return .empty()
  }
  
  private func routeToHomeMutation() -> Observable<Mutation> {
    Analytics.logEvent(
      AnalyticsEventLogin,
      parameters: [
        AnalyticsParameterSuccess: 1
      ]
    )
    
    dependency.coordinator.start(
      from: .home,
      shouldNavigationWrapped: true
    )
    
    
    // TODO: 화면 연결이 끝나면 코디네이터 코드를 제거하고 아래 코드로 대체해요.
//    steps.accept(ToodaStep.loginIsCompleted)
    
    return Observable<Mutation>.empty()
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let signInMutation = dependency.socialLoginService.tokenProvider.flatMap { [weak self] result -> Observable<Mutation> in
      guard let self = self else { return mutation }
      if result.error != nil {
        return Observable.just(
          Mutation.setSnackBarInfo(.init(
            title: "앗, 문제가 있네요. 다시 시도해보세요!",
            type: .negative
          ))
        )
      }
      return self.signInMutation(with: result.token ?? "")
    }
    
    let snackBarMutation = dependency.snackBarEventBus.map { Mutation.setSnackBarInfo($0)}
    
    return Observable.merge(
      mutation,
      signInMutation,
      snackBarMutation
    )
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state.with {
      $0.snackBarInfo = nil
    }
    
    switch mutation {
    case let .setIsAuthorized(isAuthorized):
      newState.isAuthorized = isAuthorized
    case let .setSnackBarInfo(info):
      newState.snackBarInfo = info
    }

    return newState
  }
}
