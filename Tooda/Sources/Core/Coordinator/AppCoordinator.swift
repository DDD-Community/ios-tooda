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
import SafariServices

enum TransitionStyle {
  case push
  case modal
}

enum CloseStyle {
  case root
  case target(Scene)
  case pop
  case dismiss
}

protocol AppCoordinatorType {
  func start(
    from root: Scene,
    shouldNavigationWrapped: Bool
  )
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
  
  func start(
    from root: Scene,
    shouldNavigationWrapped: Bool
  ) {
    let rootViewController: UIViewController = self.dependency.appFactory.makeViewController(from: root)
    
    if shouldNavigationWrapped {
      let navigationController = UINavigationController(rootViewController: rootViewController)
      UIApplication.shared.windows.first?.rootViewController = navigationController
    } else {
      UIApplication.shared.windows.first?.rootViewController = rootViewController
    }
    
    self.currentViewController = rootViewController
  }
  
  func transition(to scene: Scene, using style: TransitionStyle, animated: Bool, completion: (() -> Void)?) {
    guard let currentViewController = self.currentViewController else { return }
    let viewController = self.dependency.appFactory.makeViewController(from: scene)
    switch style {
    case .push:
        
      self.pushViewControllerWhenNavigationWrapped(currentViewController, viewController, animated)
      self.pushViewControllerWhenNoneNavigationWrapped(currentViewController, viewController, animated)
      
      self.currentViewController = viewController
      completion?()

    case .modal:
      currentViewController.present(
        viewController,
        animated: animated,
        completion: completion
      )
      if determineShouldConfigureCurrentViewController(scene: scene) {
        self.currentViewController = viewController
      }
    }
  }
  
  func close(style: CloseStyle, animated: Bool, completion: (() -> Void)?) {
    guard let currentViewController = self.currentViewController else { return }
    switch style {
    case .root:
      self.currentViewController?
        .navigationController?
        .popToRootViewController(animated: animated)
      completion?()
      
    case .target(let scene):
      guard let viewControllers = currentViewController.navigationController?.viewControllers else { return }
      guard let target = viewControllers.first(where: {
        switch scene {
        case .login:
          return $0 is LoginViewController
        case .home:
          return $0 is HomeViewController
        case .createNote, .modifyNote:
          return $0 is CreateNoteViewController
        case .settings:
          return $0 is SettingsViewController
        case .addStock:
          return $0 is AddStockViewController
        case .search:
          return $0 is SearchViewController
        case .noteList:
          return $0 is NoteListViewController
        case .searchRecent:
          return false
        case .stockRateInput:
          return $0 is StockRateInputViewController
        case .popUp:
          return $0 is PopUpViewController
        case .searchResult:
          return $0 is SearchResultViewController
        case .noteDetail:
          return $0 is NoteDetailViewController
        case .inAppBrowser:
          return $0 is SFSafariViewController
        }
      }) else { return }

      currentViewController
        .navigationController?
        .popToViewController(target, animated: animated)

      self.currentViewController = target
      completion?()
      
    case .pop:
      popViewControllerWhenNavigtionWrapped(currentViewController, animated)
      popViewControllerWhenNoneNavigationWrapped(currentViewController, animated)
      completion?()
      
    case .dismiss:
      if let presentingViewController = currentViewController.presentingViewController {
        currentViewController.dismiss(animated: animated, completion: {
          self.currentViewController = presentingViewController
          completion?()
        })
      } else {
        currentViewController.dismiss(animated: animated, completion: completion)
      }
    }
  }
  
  private func determineShouldConfigureCurrentViewController(scene: Scene) -> Bool {
    switch scene {
    case .inAppBrowser:
      return false
    default:
      return true
    }
  }
}

extension AppCoordinator {
  private func pushViewControllerWhenNavigationWrapped(_ currentViewController: UIViewController, _ viewController: UIViewController, _ animated: Bool) {
    if let navigationController = currentViewController as? UINavigationController {
      navigationController.pushViewController(viewController, animated: animated)
    }
  }
  
  private func pushViewControllerWhenNoneNavigationWrapped(_ currentViewController: UIViewController, _ viewController: UIViewController, _ animated: Bool) {
    currentViewController.navigationController?.pushViewController(
      viewController,
      animated: animated
    )
  }
  
  private func popViewControllerWhenNavigtionWrapped(_ currentViewController: UIViewController, _ animated: Bool) {
    if let navigationController = currentViewController as? UINavigationController {
      navigationController.popViewController(animated: animated)
      self.currentViewController = navigationController.viewControllers.last
    }
  }
  
  private func popViewControllerWhenNoneNavigationWrapped(_ currentViewController: UIViewController, _ animated: Bool) {
    currentViewController
      .navigationController?
      .popViewController(animated: animated)
    
    self.currentViewController = self.currentViewController?.navigationController?.viewControllers.last
  }
}
