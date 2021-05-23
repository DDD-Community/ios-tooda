//
//  CreateDiaryViewReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import ReactorKit

final class CreateDiaryViewReactor: Reactor {
	
	enum Action {
		case initializeForm
		case dismissView
		case regist
	}
	
	enum Mutation {
		
	}
	
	struct State {
		
	}
	
	let initialState: State
	
	init() {
		self.initialState = State()
	}
}
