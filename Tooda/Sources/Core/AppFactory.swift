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
import SafariServices

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
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          noteEventBus: NoteEventBus.event.asObservable()
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
          createDiarySectionFactory: createDiarySectionFactory,
          modifiableNoteSectionFactory: nil,
          noteEventBus: NoteEventBus.event
        ),
        modifiableNote: nil
      )
        
      let viewController = CreateNoteViewController(dateString: today, reactor: reactor, mode: .add)
      let navigationController = UINavigationController(rootViewController: viewController)
      navigationController.modalPresentationStyle = .overFullScreen
      return navigationController
        
    case .modifyNote(let dateString, let note):
        let reactor = CreateNoteViewReactor(
          dependency: .init(
            service: self.dependency.appInject.resolve(NetworkingProtocol.self),
            coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
            authorization: self.dependency.appInject.resolve(AppAuthorizationType.self),
            linkPreviewService:
              self.dependency.appInject.resolve(LinkPreViewServiceType.self),
            createDiarySectionFactory: nil,
            modifiableNoteSectionFactory: modifiableNoteSectionFactory,
            noteEventBus: NoteEventBus.event
          ),
          modifiableNote: note
        )
        
        let viewController = CreateNoteViewController(dateString: dateString, reactor: reactor, mode: .update)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        return navigationController

    case .login:
      let reactor = LoginReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          localPersistanceManager: self.dependency.appInject.resolve(LocalPersistanceManagerType.self),
          socialLoginService: self.dependency.appInject.resolve(SocialLoginServiceType.self)
          
        )
      )
      return LoginViewController(reactor: reactor)

    case .settings:
      let reactor = SettingsReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          localPersistanceManager: self.dependency.appInject.resolve(LocalPersistanceManagerType.self)
        )
      )
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

    case let .noteList(payload):
      let reactor = NoteListReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          payload: payload,
          noteEventBus: NoteEventBus.event.asObservable()
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
    case .stockRateInput(let payload, let editMode):
        let reactor = StockRateInputReactor(dependency: .init(
        coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)),
                                            payload: payload)
        
      let viewController = StockRateInputViewController(reactor: reactor, editMode: editMode)
        
      return viewController

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
          networking: self.dependency.appInject.resolve(NetworkingProtocol.self),
          noteEventBus: NoteEventBus.event.asObservable(),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self)
        )
      )

      return SearchResultViewController(reactor: reactor)

    case let .noteDetail(payload):
      let reactor = NoteDetailReactor(
        dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          linkPreviewService: self.dependency.appInject.resolve(LinkPreViewServiceType.self),
          noteEventBus: NoteEventBus.event,
          payload: payload
        )
      )

      return NoteDetailViewController(reactor: reactor)
    case let .inAppBrowser(url):
      return SFSafariViewController(url: url)
    }
  }
}
