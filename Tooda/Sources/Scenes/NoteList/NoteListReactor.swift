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
  
  typealias DateInfo = (year: Int, month: Int)

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
    var dateInfo: DateInfo
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  // MARK: Properties
  
  let dependency: Dependency
  
  lazy var initialState: State = State(
    noteListModel: [],
    isEmpty: false,
    cursor: nil,
    dateInfo: (
      year: dependency.payload.year,
      month: dependency.payload.month
    )
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
        year: initialState.dateInfo.year,
        month: initialState.dateInfo.month
        )
      )
      .map([Note].self)
      .asObservable()
      .flatMap { noteList -> Observable<Mutation> in
        if noteList.isEmpty {
          return Observable<Mutation>.just(Mutation.setIsEmpty(true))
        } else {
          let noteListModelMutation = Mutation.setNoteListModel(
            [
              NoteListModel(
                identity: Constants.sectionIdentifier,
                items: noteList
              )
            ]
          )
          return Observable<Mutation>.just(noteListModelMutation)
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
