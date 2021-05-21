//
//  HomeReactor.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class HomeReactor: Reactor {
    struct Dependency {
        let service: NetworkingProtocol
    }
    
    enum Action {
        
    }
    
    struct State {
        
    }
    
    private let dependency: Dependency
    
    let initialState: State = State()
    
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}
