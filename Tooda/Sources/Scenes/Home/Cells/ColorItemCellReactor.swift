//
//  ColorItemCellReactor.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class ColorItemCellReactor: Reactor {
	
	let scheduler: Scheduler = MainScheduler.instance
	
	enum Action {}
	
	enum Mutation {}
	
	struct State {
		var color: Color
	}
	
	let initialState: State
		
	init(color: Color) {
		self.initialState = State(color: color)
	}
}

extension ColorItemCellReactor: Hashable {
	static func == (lhs: ColorItemCellReactor, rhs: ColorItemCellReactor) -> Bool {
		// TODO... 상태 변화가 어디 까지 필요 한가??
		return lhs.currentState.color.hex == rhs.currentState.color.hex
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.currentState.color)
	}
}
