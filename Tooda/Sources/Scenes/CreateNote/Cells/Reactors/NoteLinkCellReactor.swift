//
//  DiaryLinkCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

final class NoteLinkCellReactor: Reactor {
  
  enum LinkFetchError: Error {
    case dataNotFetched
  }
  
  enum Action {
    case fetchLink
  }

  enum Mutation {
    case fetchLink(LinkPreviewResponse)
    case isLoading(Bool)
  }

  struct State {
    var isLoading: Bool = true
    var hasNotTitle: Bool = true
    var response: LinkPreviewResponse?
  }
  
  struct Dependency {
    var service: LinkPreViewServiceType
  }

  let initialState: State
  private let dependency: Dependency
  
  let payload: String
  
  private let uuid: String = UUID().uuidString

  init(
    dependency: Dependency,
    payload: String
  ) {
    initialState = State()
    self.dependency = dependency
    self.payload = payload
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .fetchLink:
        return .concat([.just(.isLoading(true)), self.fetchMetaData(), .just(.isLoading(false))])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    
    switch mutation {
      case .fetchLink(let response):
        newState.response = response
        newState.hasNotTitle = (response.title == nil)
      case .isLoading(let isLoading):
        newState.isLoading = isLoading
    }
    
    return newState
  }
}

// MARK: - Extensions

// MARK: - Mutation

extension NoteLinkCellReactor {
  private func fetchMetaData() -> Observable<Mutation> {
    let linkURLString = self.payload
    
    return Observable.create { [weak self] observer in
      self?.dependency.service.fetchMetaData(urlString: linkURLString, completion: { response in
        
        if let response = response {
          observer.onNext(Mutation.fetchLink(response))
        } else {
          observer.onError(LinkFetchError.dataNotFetched)
        }

        observer.onCompleted()
      })
      
      return Disposables.create()
    }
  }
}

// MARK: - Extensions

extension NoteLinkCellReactor: Hashable {
  static func == (lhs: NoteLinkCellReactor, rhs: NoteLinkCellReactor) -> Bool {
    return lhs.uuid == rhs.uuid
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(ObjectIdentifier(self).hashValue)
  }
}
