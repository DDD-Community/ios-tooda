//
//  SearchRecentReactor.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class SearchRecentReactor: Reactor {

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let userDefaultService: LocalPersistanceManagerType
    let coordinator: AppCoordinatorType
  }


  // MARK: Reactor

  enum Action {
    case beginSearch
  }

  enum Mutation {
    case setKeywords([SearchRecentSectionModel])
  }

  struct State {
    var keywords: [SearchRecentSectionModel]
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State = State(
    keywords: []
  )

  init(dependency: Dependency) {
    self.dependency = dependency
  }
}


// MARK: - Mutate

extension SearchRecentReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .beginSearch:
      return self.loadRecentKeyword()
    }
  }

  private func loadRecentKeyword() -> Observable<Mutation> {
    // 일단 더미로
    let dummy = [
      SearchRecentSectionModel(
        identity: .header,
        items: [
          .header
        ]
      ),
      SearchRecentSectionModel(
        identity: .keyword,
        items: [
          .keyword(.init(title: "최근 검색어 1")),
          .keyword(.init(title: "최근 검색어 2")),
          .keyword(.init(title: "최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3최근 검색어 3"))
        ]
      )
    ]

    return Observable.just(Mutation.setKeywords(dummy))
  }
}


// MARK: - Reduce

extension SearchRecentReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setKeywords(keywords):
      newState.keywords = keywords
    }

    return newState
  }
}
