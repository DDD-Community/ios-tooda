//
//  AppFactory.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Swinject
import UIKit

protocol AppFactoryType {
  func makeViewController(from scene: Scene) -> UIViewController
}

final class AppFactory: AppFactoryType {
  
  struct Dependency {
    let appInject: AppInjectRegister & AppInjectResolve
  }
  
  private let dependency: Dependency
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  func makeViewController(from scene: Scene) -> UIViewController {
    switch scene {
    case .home:
      let reactor = HomeReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )
      return HomeViewController(reactor: reactor)

    case .createNote(let today):
      let reactor = CreateNoteViewReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          authorization: self.dependency.appInject.resolve(AppAuthorizationType.self),
          linkPreviewService:
            self.dependency.appInject.resolve(LinkPreViewServiceType.self),
          createDiarySectionFactory: createDiarySectionFactory)
      )
        
      let viewController = CreateNoteViewController(reactor: reactor)
      let navigationController = UINavigationController(rootViewController: viewController)
      navigationController.modalPresentationStyle = .overFullScreen
      return navigationController

    case .login:
      let reactor = LoginReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          localPersistanceManager: self.dependency.appInject.resolve(LocalPersistanceManagerType.self)
        )
      )
      return LoginViewController(reactor: reactor)

    case .settings:
      let reactor = SettingsReactor(dependency: .init())
      return SettingsViewController(reactor: reactor)
      
    case .addStock(let completionRelay):
      
      let factory: AddStockSectionFactoryType = AddStockSectionFactory()
      
      let reator = AddStockReactor(
        dependency: .init(
          completionRelay: completionRelay,
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          sectionFactory: factory
        )
      )
      let viewController = AddStockViewController(reactor: reator)
      let navigationController = UINavigationController(rootViewController: viewController)
      navigationController.modalPresentationStyle = .overFullScreen
      return navigationController

    case .search:
      let reactor = SearchReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )

      return SearchViewController(
        reactor: reactor,
        recentViewController: self.makeViewController(from: .searchRecent) as! SearchRecentViewController,
        resultViewController: self.makeViewController(from: .searchResult) as! SearchResultViewController
      )

    case .noteList:
      let reactor = NoteListReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )
      let viewController = NoteListViewController(reactor: reactor)
      let navigationController = UINavigationController(rootViewController: viewController)
      navigationController.modalPresentationStyle = .overFullScreen
      return navigationController
    case .searchRecent:
      let reactor = SearchRecentReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          userDefaultService: self.dependency.appInject.resolve(LocalPersistanceManagerType.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )

      return SearchRecentViewController(reactor: reactor)
    case .stockRateInput(let payload):
        let reactor = StockRateInputReactor(dependency: .init(
        coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)),
                                            payload: payload)
      return StockRateInputViewController(reactor: reactor)

    case .popUp(let type):
      let reactor = PopUpReactor(
        dependency: .init(
          type: type,
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )
      return PopUpViewController(reactor: reactor).then {
        $0.modalPresentationStyle = .overFullScreen
      }
    case .searchResult:
      let reactor = SearchResultReactor(
        dependency: .init(
          networking: self.dependency.appInject.resolve(NetworkingProtocol.self)
        )
      )

      return SearchResultViewController(reactor: reactor)

    case .noteDetail:
      let reactor = NoteDetailReactor(
        dependency: .init(
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )

      return NoteDetailViewController(reactor: reactor)
    }
  }
}
