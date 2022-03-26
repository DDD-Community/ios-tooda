//
//  LoginFlow.swift
//  Tooda
//
//  Created by Lyine on 2022/03/26.
//

import UIKit
import RxFlow

final class LoginFlow: Flow {
  
  var root: Presentable {
    return self.rootViewController
  }
  
  private let rootViewController: UINavigationController = .init()
  
  struct Dependency {
    let appInject: AppInjectRegister & AppInjectResolve
  }
  
  private let dependency: Dependency
  
  
  init(with dependency: Dependency) {
    self.dependency = dependency
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step.asToodaStep else { return .none }
    
    switch step {
      case .loginIsRequired:
        return coordinateToLogin()
      case .loginIsCompleted:
        return .end(forwardToParentFlowWithStep: ToodaStep.homeIsRequired)
      default:
        return .none
    }
    
  }
}

  // MARK: - Extensions

extension LoginFlow {
  private func coordinateToLogin() -> FlowContributors {
    let reactor = LoginReactor(
      dependency: .init(
        service: self.dependency.appInject.resolve(NetworkingProtocol.self),
        coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
        localPersistanceManager: self.dependency.appInject.resolve(LocalPersistanceManagerType.self),
        socialLoginService: self.dependency.appInject.resolve(SocialLoginServiceType.self),
        snackBarEventBus: SnackBarEventBus.event.asObservable()
      )
    )
    
    let viewController = LoginViewController(reactor: reactor)
    
    self.rootViewController.pushViewController(viewController, animated: true)
    
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: reactor))
  }
}
