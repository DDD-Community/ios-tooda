//
//  SearchResultReactor.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/12/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class SearchResultReactor: Reactor {

  // MARK: Dependency

  struct Dependency {
    let networking: NetworkingProtocol
    let noteEventBus: Observable<NoteEventBus.Event>
    let coordinator: AppCoordinatorType
  }


  // MARK: Constant

  private enum Const {
    static let searchLimitCount: Int = 10
  }

  private enum Text {
    static let networkingErrorMessage = "네트워크 연결에 실패했습니다 :("
  }


  // MARK: Reactor

  enum Action {
    case search(text: String)
    case didTapNote(index: Int)
  }

  enum Mutation {
    case setSearchResult([Note])
    case createNote(Note)
    case editNote(Note)
    case deleteNote(Note)
    case setLoading(Bool)
    case setSnackbarInfo(SnackBarManager.SnackBarInfo)
  }

  struct State {
    var notes: [Note]
    var isLoading: Bool
    var isEmptyViewHidden: Bool
    var snackbarInfo: SnackBarManager.SnackBarInfo?
  }


  // MARK: Properties

  private let dependency: Dependency

  private let snackbarEvent = PublishSubject<SnackBarManager.SnackBarInfo>()

  let initialState: State = State(
    notes: [],
    isLoading: false,
    isEmptyViewHidden: true,
    snackbarInfo: nil
  )

  init(dependency: Dependency) {
    self.dependency = dependency
  }
}


// MARK: - Mutate

extension SearchResultReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .search(text):
      return Observable<Mutation>.concat([
        .just(Mutation.setLoading(true)),
        self.loadSearchResult(text: text)
      ])

    case let .didTapNote(index):
      self.pushNoteList(index: index)
      return .empty()
    }
  }

  private func loadSearchResult(text: String) -> Observable<Mutation> {
    return self.dependency.networking
      .request(SearchAPI.search(query: text, limit: Const.searchLimitCount))
      .toodaMap(SearchNoteResponse.self)
      .catch { [weak self] error in
        self?.snackbarEvent.onNext(.init(
          title: Text.networkingErrorMessage,
          type: .negative
        ))
        return .error(error)
      }
      .asObservable()
      .flatMap {
        return Observable<Mutation>.concat([
          .just(.setLoading(false)),
          .just(.setSearchResult($0.notes) )
        ])
      }
  }
}


// MARK: - Transform

extension SearchResultReactor {

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(
      mutation,
      self.dependency.noteEventBus
        .flatMap { event -> Observable<Mutation> in
          switch event {
          case let .createNote(note):
            return .just(.createNote(note))

          case let .editNode(note):
            return .just(.editNote(note))

          case let .deleteNote(note):
            return .just(.deleteNote(note))
          }
        },
      self.snackbarEvent.asObservable()
        .flatMap {
          Observable<Mutation>.concat([
            .just(.setSnackbarInfo($0)),
            .just(.setLoading(false))
          ])
        }
    )
  }
}


// MARK: - Reduce

extension SearchResultReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.snackbarInfo = nil

    switch mutation {
    case let .setSearchResult(notes):
      newState.notes = notes
      newState.isEmptyViewHidden = !notes.isEmpty

    case let .createNote(note):
      newState.notes.append(note)
      newState.isEmptyViewHidden = !newState.notes.isEmpty

    case let .editNote(note):
      guard let index = newState.notes.firstIndex(where: {
        $0.id == note.id
      }) else { break }
      newState.notes[index] = note

    case let .deleteNote(note):
      guard let index = newState.notes.firstIndex(where: {
        $0.id == note.id
      }) else { break }
      newState.notes.remove(at: index)
      newState.isEmptyViewHidden = !newState.notes.isEmpty

    case let .setLoading(isLoading):
      newState.isLoading = isLoading

    case let .setSnackbarInfo(info):
      newState.snackbarInfo = info
    }

    return newState
  }
}


// MARK: - Routing

extension SearchResultReactor {

  private func pushNoteList(index: Int) {
    guard let note = self.currentState.notes[safe: index] else { return }

    self.dependency.coordinator.transition(
      to: .noteDetail(payload: .init(
        id: note.id
      )),
      using: .push,
      animated: true,
      completion: nil
    )
  }
}
