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
  }

  struct State {
    var notes: [Note]
    var isLoading: Bool
    var isEmptyViewHidden: Bool
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State = State(
    notes: [],
    isLoading: false,
    isEmptyViewHidden: true
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

  private func mockSearchResult() -> Observable<Mutation> {
    return Observable<Mutation>.just(
      .setSearchResult([
        Note(
          id: 1,
          title: "전기차 관련 ",
          content: "#전기차  G전자는 자동차 업체는 아니기 때문에, 유명 완성차 업체에 납품을 할 때 중요한 트랙 레코드가 많진 않아요. 반면 마그나는 수십 개 자동차 업체에 부품을 납품한 회사니깐 이 둘이 합치면 시너지를 낼 수 있을 까라 ",
          createdAt: Date(),
          updatedAt: Date(),
          sticker: .angry,
          noteStocks: [
            .init(
              id: 1,
              name: "테슬라"
            ),
            .init(
              id: 2,
              name: "애플"
            )
          ],
          noteLinks: [],
          noteImages: []
        ),
        Note(
          id: 2,
          title: "전기차 관련 ",
          content: "#전기차  G전자는 자동차 업체는 아니기 때문에, 유명 완성차 업체에 납품을 할 때 중요한 트랙 레코드가 많진 않아요. 반면 마그나는 수십 개 자동차 업체에 부품을 납품한 회사니깐 이 둘이 합치면 시너지를 낼 수 있을 까라 ",
          createdAt: Date(),
          updatedAt: Date(),
          sticker: .thinking,
          noteStocks: [
            .init(
              id: 1,
              name: "테슬라"
            ),
            .init(
              id: 2,
              name: "애플"
            )
          ],
          noteLinks: [],
          noteImages: []
        ),
        Note(
          id: 3,
          title: "전기차 관련 ",
          content: "#전기차  G전자는 자동차 업체는 아니기 때문에, 유명 완성차 업체에 납품을 할 때 중요한 트랙 레코드가 많진 않아요. 반면 마그나는 수십 개 자동차 업체에 부품을 납품한 회사니깐 이 둘이 합치면 시너지를 낼 수 있을 까라 ",
          createdAt: Date(),
          updatedAt: Date(),
          sticker: .sad,
          noteStocks: [
            .init(
              id: 1,
              name: "테슬라"
            ),
            .init(
              id: 2,
              name: "애플"
            )
          ],
          noteLinks: [],
          noteImages: []
        )
      ])
    )
  }

  // TODO: 목데이터가 없어서 keep
  private func loadSearchResult(text: String) -> Observable<Mutation> {
    return self.dependency.networking
      .request(SearchAPI.search(query: text, limit: Const.searchLimitCount))
      .toodaMap(SearchNoteResponse.self)
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
        }
    )
  }
}


// MARK: - Reduce

extension SearchResultReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

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
