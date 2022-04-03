//
//  SceneDelegate.swift
//  Toda
//
//  Created by lyine on 2021/04/05.
//

import UIKit

import Swinject
import RxFlow
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  private let appInject = AppInject(container: Container())
  var window: UIWindow?
  
  private let coordinator: FlowCoordinator = .init()
  private let disposeBag: DisposeBag = .init()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let scene = (scene as? UIWindowScene) else { return }
    
    self.register()
    AppApppearance.configureAppearance()
    
    let appCoordinator = appInject.resolve(AppCoordinatorType.self)
    
    let window = UIWindow(windowScene: scene)
    window.makeKeyAndVisible()
    
    self.window = window
    
    appCoordinator.start(
      from: determineInitialScene(),
      shouldNavigationWrapped: true
    )
    
    // FIXME: 코디네이팅 연결이 완료되었을 때 주석을 해제해요.
//    self.coordinatorLogStart()
//    self.coordinateToAppFlow(with: scene)
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
      // Called as the scene is being released by the system.
      // This occurs shortly after the scene enters the background, or when its session is discarded.
      // Release any resources associated with this scene that can be re-created the next time the scene connects.
      // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  func determineInitialScene() -> Scene {
    let localPersistanceManager = appInject.resolve(LocalPersistanceManagerType.self)
    if let _: AppToken = localPersistanceManager.objectValue(forKey: .appToken) {
      return .home
    } else {
      return .login
    }
  }
}

extension SceneDelegate {
  private func register() {
    self.appInject.registerCore()
  }
}

// MARK: - RxFlows Extensions

extension SceneDelegate {
  private func coordinateToAppFlow(with windowScene: UIWindowScene) {
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    
    let appFlow = AppFlow(with: window, dependency: .init(appInject: self.appInject))
    
    let appStepper = AppStepper(dependency: .init(
      persistenceManager: self.appInject.resolve(LocalPersistanceManagerType.self)
    ))
    
    coordinator.coordinate(flow: appFlow, with: appStepper)
    
    window.makeKeyAndVisible()
  }
  
  private func coordinatorLogStart() {
    coordinator.rx.willNavigate
      .subscribe(onNext: { flow, step in
        let currentFlow = "\(flow)".split(separator: ".").last ?? "no flow"
        print("➡️ will navigate to flow = \(currentFlow) and step = \(step)")
      })
      .disposed(by: disposeBag)
    
      // FIXME: didNavigate 기능을 필요시 구현하도록 합니다.
  }
}
