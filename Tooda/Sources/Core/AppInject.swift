//
//  AppInject.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Swinject
import Foundation

class AppInject {
	
	private init() { }
	
	static let rootContainer: Container = {
		let container = Container()
		
		// MARK: Networking
		container.register(Networking.self) { _ in
			return Networking(logger: [AccessTokenPlugin()])
		}.inObjectScope(.container)
		
		// MARK: Repositories
		container.register(ColorRepository.self) { r in
			return DefaultColorRepository(networking: r.resolve(Networking.self)!)
		}.inObjectScope(.container)
		
		// MARK: UseCases
		
		container.register(ColorUseCase.self) { r in
			return DefaultColorUseCase(repository: r.resolve(ColorRepository.self)!)
		}.inObjectScope(.container)
		
		return container
	}()
}
