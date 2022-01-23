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
import Firebase

final class LoginReactor: Reactor {
  
  // MARK: - Constants
  
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let localPersistanceManager: LocalPersistanceManagerType
    let socialLoginService: SocialLoginServiceType
  }
  
  enum Action {
    case login
  }
  
  enum Mutation {
    case setAppToken(token: AppToken)
    case setIsAuthorized(isAuthorized: Bool)
  }
  
  struct State {
    var isAuthorized: Bool
  }
  
  // MARK: - Properties
  
  private let dependency: Dependency
  
  private let disposeBag = DisposeBag()
  
  let initialState: State = State(isAuthorized: false)
  
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
              // TODO: 에러처리
              return Observable.empty()
            } else {
              return Observable<Mutation>.concat([
                Observable<Mutation>.just(Mutation.setAppToken(token: token)),
                Observable<Mutation>.just(Mutation.setIsAuthorized(isAuthorized: true)),
                self.routeToHomeMutation()
              ])
            }
          }
      }
  }
  
  private func routeToHomeMutation() -> Observable<Mutation> {
    FirebaseAnalytics.Analytics.logEvent(
        AnalyticsEventLogin,
      parameters: [
        AnalyticsParameterSuccess: 1
      ]
    )
    
    dependency.coordinator.start(
      from: .home,
      shouldNavigationWrapped: true
    )
    
    return Observable<Mutation>.empty()
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let new = dependency.socialLoginService.tokenProvider.flatMap { [weak self] result -> Observable<Mutation> in
      guard let self = self else { return mutation }
      return self.signInMutation(with: result.token ?? "")
    }
    return Observable.merge(mutation, new)
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setAppToken(token):
      dependency.localPersistanceManager.setObject(
        value: token,
        forKey: .appToken
      )
    case let .setIsAuthorized(isAuthorized):
      newState.isAuthorized = isAuthorized
    }

    return newState
  }
}
