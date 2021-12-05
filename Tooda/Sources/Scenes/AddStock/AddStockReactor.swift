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
    case nextButtonDidTapped(name: String)
    case cellItemDidSelected(IndexPath)
  }
  
  enum Mutation {
    case fetchSearchResultSection([AddStockSection])
    case nextButtonDidChanged(Bool)
  }
  
  struct Dependency {
    let completionRelay: PublishRelay<NoteStock>
    let coordinator: AppCoordinatorType
    let service: NetworkingProtocol
    let sectionFactory: AddStockSectionFactoryType
  }
  
  struct State {
    var sections: [AddStockSection] = [
      .init(identity: .list, items: [])
    ]
    
    var nextButtonDidChanged: Bool = false
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
        return .concat([
          self.searchTextDidChanged(keyword),
          .just(.nextButtonDidChanged(!keyword.isEmpty && keyword.count >= 1))
        ])
      case .dismiss:
        return self.dissmissView()
      case .nextButtonDidTapped(let name):
        return self.nextButtonDidTapped(name)
      case .cellItemDidSelected(let indexPath):
        return self.cellItemDidSelected(indexPath)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    
    var state = state
    
    switch mutation {
      case .fetchSearchResultSection(let sections):
        state.sections = sections
      case .nextButtonDidChanged(let isEnabled):
        state.nextButtonDidChanged = isEnabled
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
  
  // TODO: Coordinator의 transition에 NavigationController을 씌운 ViewController에 대한 처리 메소드를 추가할 예정이에요.
  private func nextButtonDidTapped(_ name: String) -> Observable<Mutation> {
    
    let payload = StockRateInputReactor.Payload(name: name,
                                                completion: self.dependency.completionRelay)
    
    self.dependency.coordinator.transition(to: .stockRateInput(payload: payload), using: .push, animated: true, completion: nil)
    
    return .empty()
  }
}
