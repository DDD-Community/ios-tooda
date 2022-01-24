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

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
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
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State = State(sectionModel: [])

  init(dependency: Dependency) {
    self.dependency = dependency
  }
}


// MARK: - Mutate

extension NoteDetailReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      loadDataMutation()
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
    return dependency.service.request(NoteAPI.detail(id: ""))
      .map(Note.self)
      .asObservable()
      .flatMap { note -> Observable<Mutation> in
        let sectionModels = [
          NoteDetailSection(
            identity: .header,
            items: [
              .sticker(note.sticker ?? Sticker.wow),
              .title(note.title, note.updatedAt),
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
