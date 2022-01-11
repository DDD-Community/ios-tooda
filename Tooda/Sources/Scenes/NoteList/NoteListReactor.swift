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

  struct Payload {
    let year: Int
    let month: Int
  }
  
  enum Constants {
    static let sectionIdentifier = "NoteListSection"
  }
  
  // MARK: Reactor
  
  enum Action {
    case initialLoad
    case dismiss
  }
  
  enum Mutation {
    case setIsEmpty(Bool)
    case setPayload(Payload)
    case setNoteListModel([NoteListModel])
  }
  
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let payload: Payload
  }
  
  struct State {
    var noteListModel: [NoteListModel]
    var isEmpty: Bool
    let fetchWindowSize: Int = 15
    var cursor: Int?
    var payload: Payload?
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State = State(
    noteListModel: [],
    isEmpty: false,
    cursor: nil,
    payload: nil
  )
}

// MARK: - Mutate

extension NoteListReactor {
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialLoad:
      return loadMutation()
    case .dismiss:
      return dismissMutation()
    }
  }
  
  private func dismissMutation() -> Observable<Mutation> {
    dependency.coordinator.close(
      style: .dismiss,
      animated: true,
      completion: nil
    )
    return Observable<Mutation>.empty()
  }
  
  private func loadMutation() -> Observable<Mutation> {
    return dependency.service.request(
      NoteAPI.monthlyList(
        limit: initialState.fetchWindowSize,
        cursor: initialState.cursor,
        year: dependency.payload.year,
        month: dependency.payload.month
        )
      )
      .map([Note].self)
      .asObservable()
      .flatMap { [weak self] noteList -> Observable<Mutation> in
        guard let self = self else { return Observable<Mutation>.empty() }
        let payloadStream = Observable.just(Mutation.setPayload(self.dependency.payload))
        if noteList.isEmpty {
          return Observable<Mutation>.concat([
            payloadStream,
            Observable.just(Mutation.setIsEmpty(true))
          ])
        } else {
          let noteListModelMutation = Mutation.setNoteListModel(
            [
              NoteListModel(
                identity: Constants.sectionIdentifier,
                items: noteList
              )
            ]
          )
          return Observable<Mutation>.concat([
            payloadStream,
            Observable.just(noteListModelMutation)
          ])
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
    case let .setPayload(payload):
      newState.payload = payload
    }
    
    return newState
  }
}
