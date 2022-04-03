//
//  AppFlow.swift
//  Tooda
//
//  Created by Lyine on 2022/03/26.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

// Flow는 AnyObject를 준수하므로 class로 선언해주어야 합니다!
final class AppFlow: Flow {
  var root: Presentable {
    return self.rootWindow
  }
  
  struct Dependency {
    let appInject: AppInjectRegister & AppInjectResolve
  }
  
  private let rootWindow: UIWindow
  private let dependency: Dependency
  
  init(
    with window: UIWindow,
    dependency: Dependency
  ) {
    self.rootWindow = window
    self.dependency = dependency
  }
  
  deinit {
    print("\(type(of: self)): \(#function))")
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step.asToodaStep else { return .none }
    
    switch step {
      case .loginIsRequired:
        return coordinateToLogin()
        
      case .loginIsCompleted, .homeIsRequired:
        return coordinateToHome()
        
      default:
        return .none
    }
  }
  
  private func coordinateToLogin() -> FlowContributors {
    let loginFlow = LoginFlow(with: .init(appInject: self.dependency.appInject))
    
    Flows.use(loginFlow, when: .created) { [unowned self] root in
      self.rootWindow.rootViewController = root
    }
    
    let nextStep = OneStepper(withSingleStep: ToodaStep.loginIsRequired)
    
    return .one(
      flowContributor: .contribute(
        withNextPresentable: loginFlow,
        withNextStepper: nextStep
      )
    )
  }
  
  // TODO: HomeFlow를 연결할 예정이에요.
  private func coordinateToHome() -> FlowContributors {
    return .none
  }
}
