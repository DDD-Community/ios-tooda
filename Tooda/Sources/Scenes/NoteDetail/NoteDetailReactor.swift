//
//  NoteDetailReactor.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/01/01.
//

import Foundation

import ReactorKit
import RxSwift

final class NoteDetailReactor: Reactor {
  
  struct Payload {
    let id: Int
  }

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let payload: Payload
  }

  // MARK: Reactor

  enum Action {
    case loadData
    case back
  }

  enum Mutation {
    case setNoteDetailSectionModel([NoteDetailSection])
  }

  struct State {
    var sectionModel: [NoteDetailSection]
    let noteID: Int
    
    static func generateInitialState(noteID: Int) -> State {
      return State(sectionModel: [], noteID: noteID)
    }
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State

  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState =
      State.generateInitialState(noteID: dependency.payload.id)
  }
}


// MARK: - Mutate

extension NoteDetailReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return loadDataMutation()
    case .back:
      self.dependency.coordinator.close(
        style: .pop,
        animated: true,
        completion: nil
      )
      return .empty()
    }
  }
  
  private func loadDataMutation() -> Observable<Mutation> {
    return dependency.service.request(NoteAPI.detail(id: initialState.noteID))
      .map(Note.self)
      .asObservable()
      .flatMap { note -> Observable<Mutation> in
        let sectionModels = [
          NoteDetailSection(
            identity: .header,
            items: [
              .sticker(note.sticker ?? Sticker.wow),
              .title(note.title, note.updatedAt ?? note.createdAt),
              .content(note.content)
            ]
          )
        ]
        return Observable<Mutation>.just(
          Mutation.setNoteDetailSectionModel(sectionModels)
        )
      }
  }
}


// MARK: - Reduce

extension NoteDetailReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setNoteDetailSectionModel(sectionModel):
      newState.sectionModel = sectionModel
    }
    
    return newState
  }
}
