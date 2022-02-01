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
import Then

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
    case pagnationLoad(willDisplayIndex: Int)
    case addNoteButtonTap
    case noteCellTap(index: Int)
  }
  
  enum Mutation {
    case setIsEmpty(Bool)
    case setIsLoading(Bool)
    case setNextCursor(Int?)
    case setNoteListModel([NoteListModel])
    case setPagnationLoadedNotes([Note])
  }
  
  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let payload: Payload
    let noteEventBus: Observable<NoteEventBus.Event>
  }
  
  struct State: Then {
    var noteListModel: [NoteListModel]
    var isEmpty: Bool?
    let fetchWindowSize: Int = 15
    let prefetchThreshold: Int = 4
    var isLoading: Bool = false
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
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(
      mutation,
      dependency.noteEventBus
        .flatMap { [weak self] event -> Observable<Mutation> in
          guard let self = self else { return Observable<Mutation>.empty() }
          switch event {
          case let .createNote(note):
            return self.addNoteListMutation(note: note)

          case let .editNode(note):
            return self.modifyNoteListMutation(note: note)

          case let .deleteNote(note):
            return self.deleteNoteListMutation(note: note)
          }
        }
    )
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initialLoad:
      return loadMutation()
    case .dismiss:
      return dismissMutation()
    case let .pagnationLoad(willDisplayIndex):
      return pagnationLoadMutation(nextDisplayIndex: willDisplayIndex)
    case .addNoteButtonTap:
      return routeToCreateNote()
    case let .noteCellTap(selectedIndex):
      return routeToNoteDetail(selectedIndex: selectedIndex)
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
  
  private func routeToCreateNote() -> Observable<Mutation> {
    dependency.coordinator.transition(
      to: .createNote(dateString: "\(currentState.dateInfo.year).\(currentState.dateInfo.month)"),
      using: .modal,
      animated: true,
      completion: nil
    )
    return Observable<Mutation>.empty()
  }
  
  private func routeToNoteDetail(selectedIndex: Int) -> Observable<Mutation> {
    guard let noteID = currentState.noteListModel.first?.items[safe: selectedIndex]?.id else { return Observable<Mutation>.empty() }
    dependency.coordinator.transition(
      to: .noteDetail(payload: NoteDetailReactor.Payload(id: noteID)),
      using: .push,
      animated: true,
      completion: nil
    )
    return Observable<Mutation>.empty()
  }
  
  private func addNoteListMutation(note: Note) -> Observable<Mutation> {
    guard var noteListModel = currentState.noteListModel.first else { return Observable.empty() }
    noteListModel.items.insert(note, at: 0)
    
    return Observable.just(Mutation.setNoteListModel([noteListModel]))
  }
  
  private func deleteNoteListMutation(note: Note) -> Observable<Mutation> {
    guard var noteListModel = currentState.noteListModel.first else { return Observable.empty() }
    let notes = noteListModel.items.filter { $0.id != note.id }
    noteListModel.items = notes
    
    return Observable.just(Mutation.setNoteListModel([noteListModel]))
  }
  
  private func modifyNoteListMutation(note: Note) -> Observable<Mutation> {
    guard var noteListModel = currentState.noteListModel.first else { return Observable.empty() }
    if let index = noteListModel.items.firstIndex(where: { $0.id == note.id }) {
      noteListModel.items[index] = note
    }
    
    return Observable.just(Mutation.setNoteListModel([noteListModel]))
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
      .map(NoteListDTO.self)
      .catchAndReturn(NoteListDTO(cursor: nil, noteList: []))
      .asObservable()
      .flatMap { noteDTO -> Observable<Mutation> in
        guard let noteList = noteDTO.noteList else {
          return Observable<Mutation>.empty()
        }
        if noteList.isEmpty {
          return Observable<Mutation>.concat([
            Observable.just(Mutation.setIsLoading(true)),
            Observable.just(Mutation.setIsEmpty(true)),
            Observable.just(Mutation.setIsLoading(false))
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
            Observable.just(Mutation.setIsLoading(true)),
            Observable.just(Mutation.setIsEmpty(false)),
            Observable.just(noteListModelMutation),
            Observable.just(Mutation.setNextCursor(noteDTO.cursor)),
            Observable.just(Mutation.setIsLoading(false))
          ])
        }
    }
  }
  
  private func pagnationLoadMutation(nextDisplayIndex: Int) -> Observable<Mutation> {
    guard let itemCount = currentState.noteListModel.first?.items.count,
      (itemCount - currentState.prefetchThreshold) <= nextDisplayIndex,
      !currentState.isLoading,
      currentState.cursor != nil else {
      return Observable<Mutation>.empty()
    }
    
    return dependency.service.request(
      NoteAPI.monthlyList(
        limit: currentState.fetchWindowSize,
        cursor: currentState.cursor,
        year: dependency.payload.year,
        month: dependency.payload.month
        )
      )
      .map(NoteListDTO.self)
      .asObservable()
      .flatMap { noteDTO -> Observable<Mutation> in
        guard let noteList = noteDTO.noteList else {
          return Observable<Mutation>.empty()
        }
        
        return Observable<Mutation>.concat([
          Observable.just(Mutation.setIsLoading(true)),
          Observable.just(Mutation.setNextCursor(noteDTO.cursor)),
          Observable.just(Mutation.setPagnationLoadedNotes(noteList)),
          Observable.just(Mutation.setIsLoading(false))
        ])
    }
  }
}

// MARK: - Reduce

extension NoteListReactor {
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state.with {
      $0.isEmpty = nil
    }
    
    switch mutation {
    case let .setNoteListModel(model):
      newState.noteListModel = model
    case let .setIsEmpty(isEmpty):
      newState.isEmpty = isEmpty
    case let .setIsLoading(isLoading):
      newState.isLoading = isLoading
    case let .setNextCursor(cursor):
      newState.cursor = cursor
    case let .setPagnationLoadedNotes(notes):
      if var model = newState.noteListModel.first {
        model.items.append(contentsOf: notes)
        newState.noteListModel = [model]
      }
    }
    
    return newState
  }
}
