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
    case search(text: String)
  }

  enum Mutation {
    case setKeywords([SearchRecentSectionModel])
    case updateKeywords(keyword: SearchRecentKeywordCell.ViewModel)
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

    case let .search(text):
      return self.createKeyword(text)
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

  private func createKeyword(_ text: String) -> Observable<Mutation> {
    var localKeywords: [String] = self.dependency
      .userDefaultService
      .value(forKey: .recentSearchKeyword) ?? []

    localKeywords.insert(text, at: 0)

    self.dependency.userDefaultService.set(
      value: localKeywords,
      forKey: .recentSearchKeyword
    )

    return Observable<Mutation>.just(
      Mutation.updateKeywords(
        keyword: SearchRecentKeywordCell.ViewModel(
          title: text
        )
      )
    )
  }
}


// MARK: - Reduce

extension SearchRecentReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setKeywords(keywords):
      newState.keywords = keywords

    case let .updateKeywords(keyword):
      guard let index = newState.keywords.firstIndex(where: {
        $0.identity == .keyword
      }) else { break }

      newState.keywords[index].items.insert(
        .keyword(keyword),
        at: 0
      )
    }
    return newState
  }
}
