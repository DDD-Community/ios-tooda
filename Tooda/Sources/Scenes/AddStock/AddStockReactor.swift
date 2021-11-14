  //
  //  AddStockReactor.swift
  //  Tooda
  //
  //  Created by Lyine on 2021/10/31.
  //  Copyright © 2021 DTS. All rights reserved.
  //

import Foundation
import Then
import ReactorKit
import RxSwift
import RxRelay

final class AddStockReactor: Reactor {
  
  // MARK: Reactor
  
  enum Action {
    case searchTextDidChanged(String)
    case dismiss
    case cellItemDidSelected(IndexPath)
  }
  
  enum Mutation {
    case fetchSearchResultSection([AddStockSection])
    case nextButtonDidChanged(Bool)
  }
  
  struct Dependency {
    let completionRelay: PublishRelay<String>
    let coordinator: AppCoordinatorType
    let service: NetworkingProtocol
    let sectionFactory: AddStockSectionFactoryType
  }
  
  struct State: Then {
    var sections: [AddStockSection] = [
      .init(identity: .list, items: [])
    ]
    
    var nextButtonDidChanged: Bool?
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
      case .cellItemDidSelected(let indexPath):
        return self.cellItemDidSelected(indexPath)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    
    var state = State().with {
      $0.sections = state.sections
      $0.nextButtonDidChanged = nil
    }
    
    switch mutation {
      case .fetchSearchResultSection(let sections):
        state.sections = sections
      case .nextButtonDidChanged(let didChanged):
        state.nextButtonDidChanged = didChanged
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
  // TODO: API Response -> Codable Entity -> Section Mutaion 전달 예정
  private func searchTextDidChanged(_ keyword: String) -> Observable<Mutation> {
    self.dependency.service.request(StockAPI.search(keyword: keyword))
      .asObservable()
      .map([Stock].self)
      .flatMap { [weak self] stocks -> Observable<Mutation> in
        let sections = self?.dependency.sectionFactory.searchResult(stocks) ?? []
        return .just(.fetchSearchResultSection(sections))
      }
  }
}

// MARK: Mutation

extension AddStockReactor {
  private func cellItemDidSelected(_ indexPath: IndexPath) -> Observable<Mutation> {
    
    guard let section = self.currentState.sections[safe: indexPath.section],
          let sectionItem = section.items[safe: indexPath.row] else { return .empty() }
    
    switch sectionItem {
      case .item(let reactor):
        
        let isEnabeld = !reactor.dependency.name.isEmpty
        
        return .just(.nextButtonDidChanged(isEnabeld))
    }

  }
}
