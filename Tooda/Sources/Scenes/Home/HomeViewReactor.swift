//
//  HomeViewReactor.swift
//  Toda
//
//  Created by lyine on 2021/04/07.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class HomeViewReactor: Reactor {
	
	let scheduler: Scheduler = MainScheduler.instance
	
	enum Action {
		case fetchColors
		case removeItem(Int)
	}
	
	enum Mutation {
		case fetchColors([Color])
		case removeItem(Int)
	}
	
	struct State {
		var sections: [ColorSection]
	}
	
	let initialState: State
	let service: ColorUseCase
	
	let factory: ([Color]) -> [ColorSection]
	
	init(service: ColorUseCase, factory: @escaping ([Color]) -> [ColorSection]) {
		self.initialState = .init(sections: [])
		self.service = service
		self.factory = factory
	}
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
			case .fetchColors:
				return fetchColors().flatMap { colors -> Observable<Mutation> in
					return Observable.just(Mutation.fetchColors(colors))
				}
			case .removeItem(let row):
				return .just(Mutation.removeItem(row))
		}
	}
	
	func reduce(state: State, mutation: Mutation) -> State {
		var newState = state
		switch mutation {
			case .fetchColors(let colors):
				newState.sections = self.factory(colors)
			case .removeItem(let row):
				newState.sections[ColorSection.Identity.item.rawValue].items.remove(at: row)
		}
		
		return newState
	}
	
	private func fetchColors() -> Observable<[Color]> {
		return self.service.colorList()
			.compactMap { JSONDecoder.decodeOptional($0, type: [Color].self) }
	}
}
