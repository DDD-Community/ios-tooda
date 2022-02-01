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
  }


  // MARK: Constant

  private enum Const {
    static let searchLimitCount: Int = 10
  }


  // MARK: Reactor

  enum Action {
    case search(text: String)
  }

  enum Mutation {
    case setSearchResult([Note])
  }

  struct State {
    var notes: [Note]
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State = State(notes: [])

  init(dependency: Dependency) {
    self.dependency = dependency
  }
}


// MARK: - Mutate

extension SearchResultReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .search(text):
      return self.mockSearchResult()
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
      .map([Note].self)
      .asObservable()
      .map { Mutation.setSearchResult($0) }
  }
}


// MARK: - Reduce

extension SearchResultReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setSearchResult(notes):
      newState.notes = notes
    }

    return newState
  }
}
