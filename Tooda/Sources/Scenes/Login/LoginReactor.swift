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

final class LoginReactor: Reactor {
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
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
  
  private let dependency: Dependency
  
  private let disposeBag = DisposeBag()
  
  let initialState: State = State(isAuthorized: false)
  
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
      .flatMap { token -> Observable<Mutation> in
        let mutation = Mutation.setAppToken(token: token)
        return Observable<Mutation>.just(mutation)
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
    case let .setAppToken(token):
      print(token)
    case let .setIsAuthorized(isAuthorized):
      newState.isAuthorized = isAuthorized
    }

    return newState
  }
}
