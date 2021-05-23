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
  }
  
  func resolve<Object>(_ serviceType: Object.Type) -> Object {
    return container.resolve(serviceType)!
  }
  
        dependency: .init(
          service: resolve(NetworkingProtocol.self)
        )
      )
    }
  }
}
