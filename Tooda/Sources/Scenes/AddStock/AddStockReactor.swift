  //
  //  AddStockReactor.swift
  //  Tooda
  //
  //  Created by Lyine on 2021/10/31.
  //  Copyright © 2021 DTS. All rights reserved.
  //

import Foundation

import ReactorKit
import RxSwift
import RxRelay

final class AddStockReactor: Reactor {
  
  // MARK: Reactor
  
  enum Action {
    case searchTextDidChanged(String)
    case dismiss
  }
  
  enum Mutation {
    case fetchSearchResultSection([AddStockSection])
  }
  
  struct Dependency {
    let completionRelay: PublishRelay<String>
    let coordinator: AppCoordinatorType
    let service: NetworkingProtocol
  }
  
  struct State {
    var sections: [AddStockSection] = [
      .init(identity: .list, items: [])
    ]
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State()
  }
  
    // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
}

// MARK: - Extensions

extension AddStockReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .searchTextDidChanged(let keyword):
        return self.searchTextDidChanged(keyword)
      case .dismiss:
        return self.dissmissView()
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    
    switch mutation {
      case .fetchSearchResultSection(let sections):
        state.sections = sections
    }
    
    return state
  }
}

// MARK: Coordinator

extension AddStockReactor {
  private func dissmissView() -> Observable<Mutation> {
    self.dependency.coordinator.close(
      style: .dismiss,
      animated: true,
      completion: nil
    )
    
    return .empty()
  }
}

// MARK: Seacrh Stock

extension AddStockReactor {
  private func searchTextDidChanged(_ keyword: String) -> Observable<Mutation> {
    self.dependency.service.request(StockAPI.search(keyword: keyword))
      .asObservable()
      .mapString()
      .debug()
      // TestCode
      .flatMap { _ -> Observable<Mutation> in
        return .empty()
      }
  }
}
