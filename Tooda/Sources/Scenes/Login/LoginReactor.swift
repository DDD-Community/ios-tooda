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
import Firebase

final class LoginReactor: Reactor {
  
  // MARK: - Constants
  
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let localPersistanceManager: LocalPersistanceManagerType
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
      return loginMutation()
    }
  }
  
  private func loginMutation() -> Observable<Mutation> {
    return dependency.service
      .request(AuthAPI.signUp(uuidString: deviceUUID() ?? ""))
      .map(AppToken.self)
      .asObservable()
      .flatMap { [weak self] token -> Observable<Mutation> in
        guard let self = self else { return Observable.empty() }
        let mutation = Mutation.setAppToken(token: token)
        return Observable<Mutation>.concat([
          Observable<Mutation>.just(mutation),
          self.routeToHomeMutation()
        ])
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
