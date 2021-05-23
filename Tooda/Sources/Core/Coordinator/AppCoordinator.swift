//
//  AppCoordinator.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import Swinject

enum TransitionStyle {
  case push
  case modal
}

protocol AppCoordinatorType {
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool)
}

final class AppCoordinator {
  
  struct Dependency {
    let appInject: AppInjectRegister & AppInjectResolve
    let navigationController: UINavigationController
  }
  
  private let dependency: Dependency
  
  private var currentViewController: UIViewController
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.currentViewController = dependency.navigationController
  }
  
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) {
    let viewController = self.dependency.appInject.makeViewController(from: scene)
    switch style {
    case .push:
      self.dependency.navigationController.pushViewController(viewController, animated: animated)
    case .modal:
      self.currentViewController.present(viewController, animated: animated)
    }
  }
}
