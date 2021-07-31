//
//  AppInject.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Swinject
import Foundation

protocol AppInjectRegister {
  func registerCore()
}

protocol AppInjectResolve {
  func resolve<Object>(_ serviceType: Object.Type) -> Object
}

final class AppInject: AppInjectRegister, AppInjectResolve {
  
  private let container: Container
  
  init(container: Container) {
    self.container = container
  }
  
  func registerCore() {
    container.register(NetworkingProtocol.self) { _ in
      Networking(logger: [AccessTokenPlugin()])
    }
    
    container.register(AppCoordinatorType.self) { _ in
      AppCoordinator(
        dependency: .init(
          appFactory: self.resolve(AppFactoryType.self)
        )
      )
    }
    
    container.register(AppFactoryType.self) { _ in
      AppFactory(
        dependency: .init(
          appInject: self
        )
      )
    }
    
    container.register(UserDefaultsServiceType.self) { _ in
      UserDefaultsService()
    }
    
    
    container.register(AppAuthorizationType.self) { _ in
      RxAuthorization()
    }
  }
  
  func resolve<Object>(_ serviceType: Object.Type) -> Object {
    return container.resolve(serviceType)!
  }
}
