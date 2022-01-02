//
//  NoteListReactor.swift
//  Tooda
//
//  Created by 황재욱 on 2021/10/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class NoteListReactor: Reactor {
  
  // MARK: Constants
  
  enum Constants {
    static let sectionIdentifier = "NoteListSection"
  }
  
  // MARK: Reactor
  
  enum Action {
    case initialLoad
  }
  
  enum Mutation {
    case setIsEmpty(Bool)
    case setNoteListModel([NoteListModel])
  }
  
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
  }
  
  struct State {
    var noteListModel: [NoteListModel]
    var isEmpty: Bool
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State = State(noteListModel: [], isEmpty: false)
}

// MARK: - Mutate

extension NoteListReactor {
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialLoad:
      return loadMutation()
    }
  }
  
  private func loadMutation() -> Observable<Mutation> {
    return dependency.service.request(NoteAPI.list(limit: 15, cursor: 0))
      .map([Note].self)
      .asObservable()
      .map {
        if $0.isEmpty {
          return Mutation.setIsEmpty(true)
        } else {
          return Mutation.setNoteListModel(
            [
              NoteListModel(
                identity: Constants.sectionIdentifier,
                items: $0
              )
            ]
          )
        }
    }
  }
}

// MARK: - Reduce

extension NoteListReactor {
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.isEmpty = false
    
    switch mutation {
    case let .setNoteListModel(model):
      newState.noteListModel = model
    case let .setIsEmpty(isEmpty):
      newState.isEmpty = isEmpty
    }
    
    return newState
  }
}
