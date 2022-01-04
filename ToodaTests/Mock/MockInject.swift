//
//  MockInject.swift
//  ToodaTests
//
//  Created by 황재욱 on 2021/12/26.
//

import Foundation
import Swinject
@testable import Tooda

final class MockInject: AppInjectRegister, AppInjectResolve {
  
  private let container: Container
  
  init(container: Container) {
    self.container = container
    registerCore()
  }
  
  func registerCore() {
    container.register(NetworkingProtocol.self) { _ in
      MockNetworking()
    }
    .inObjectScope(.container)
    
    container.register(AppCoordinatorType.self) { _ in
      MockCoordinator()
    }
    .inObjectScope(.container)
  }
  
  func resolve<Object>(_ serviceType: Object.Type) -> Object {
    return container.resolve(serviceType)!
  }
  
  func resolve<Object>(_ serviceType: Object.Type, name: String?) -> Object {
    return container.resolve(serviceType, name: name)!
  }
}
