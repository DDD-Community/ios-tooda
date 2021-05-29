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

enum CloseStyle {
  case root
  case target(UIViewController)
  case pop
  case dismiss
}

protocol AppCoordinatorType {
  func start(from root: UIViewController)
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?)
  func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?)
}

extension AppCoordinatorType {
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)? = nil) {
    self.transition(to: scene, using: style, animated: animated, completion: completion)
  }
  func close(style: CloseStyle, animated: Bool, completion: (() -> Void)? = nil) {
    self.close(style: style, animated: animated, completion: completion)
  }
}

final class AppCoordinator: AppCoordinatorType {
  
  struct Dependency {
    let appFactory: AppFactoryType
  }
  
  private let dependency: Dependency
  
  private var currentViewController: UIViewController?
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  func start(from root: UIViewController) {
    self.currentViewController = root
//    self.transition(to: .home, using: .push, animated: true)
  }
  
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
    guard let currentViewController = self.currentViewController else { return }
    let viewController = self.dependency.appFactory.makeViewController(from: scene)
    switch style {
    case .push:
      currentViewController.navigationController?.pushViewController(
        viewController,
        animated: animated
      )
      self.currentViewController = viewController
      completion?()

    case .modal:
      currentViewController.present(
        viewController,
        animated: animated,
        completion: completion
      )
      self.currentViewController = viewController
    }
  }
  
  func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
    switch style {
    case .root:
      self.currentViewController?
        .navigationController?
        .popToRootViewController(animated: animated)
      completion?()
      
    case .target(let viewController):
      self.currentViewController?
        .navigationController?
        .popToViewController(viewController, animated: animated)
      completion?()
      
    case .pop:
      self.currentViewController?
        .navigationController?
        .popViewController(animated: animated)
      completion?()
      
    case .dismiss:
      self.currentViewController?.dismiss(animated: animated, completion: completion)
    }
  }
}
