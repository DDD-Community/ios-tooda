//
//  HomeFlow.swift
//  Tooda
//
//  Created by Lyine on 2022/03/26.
//

import UIKit

import RxFlow
import RxRelay

final class HomeFlow: Flow {
  
  // MARK: - Property
  
  var root: Presentable {
    return self.rootViewController
  }
  
  struct Dependency {
    let appInject: AppInjectRegister & AppInjectResolve
  }
  
  private let dependency: Dependency
  
  private let rootViewController = UINavigationController()
  
  // MARK: - Init
  
  init(with dependency: Dependency) {
    self.dependency = dependency
  }
  
  // MARK: - Navigate
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step.asToodaStep else { return .none }
    
    switch step {
      case .homeIsRequired:
        return coordinateToHome()
      default:
        return .none
    }
  }
  
  deinit {
    print("\(type(of: self)): \(#function)")
  }
}

// MARK: - Extension

private extension HomeFlow {
  func coordinateToHome() -> FlowContributors {
    let reactor = HomeReactor(
      dependency: .init(
        service: self.dependency.appInject.resolve(NetworkingProtocol.self),
        coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
        noteEventBus: NoteEventBus.event.asObservable()
      )
    )
    let viewController =  HomeViewController(reactor: reactor)
    
    self.rootViewController.setViewControllers([viewController], animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: viewController,
                                             withNextStepper: reactor))
  }
}
