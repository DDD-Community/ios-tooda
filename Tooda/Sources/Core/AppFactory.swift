//
//  AppFactory.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import Swinject

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
      case .createNote:
        let reactor = CreateNoteViewReactor(dependency: .init(
          service: self.dependency.appInject.resolve(NetworkingProtocol.self),
          coordinator: self.dependency.appInject.resolve(AppCoordinatorType.self),
          createDiarySectionFactory: createDiarySectionFactory
                                             ))
        return CreateNoteViewController(reactor: reactor)
    }
  }
}