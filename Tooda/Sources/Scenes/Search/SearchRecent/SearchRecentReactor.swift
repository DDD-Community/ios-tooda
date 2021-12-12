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
    case remove(index: Int)
    case removeAll
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

    case let .search(text):
      return self.createKeyword(text)

    case let .remove(index):
      return self.removedKeyword(index)

    case .removeAll:
      return self.removeAllKeyword()
    }
  }

  private func loadRecentKeyword() -> Observable<Mutation> {
    if let localKeywords: [String] = self.dependency
        .userDefaultService
        .value(forKey: .recentSearchKeyword) {
      return Observable.just(
        Mutation.setKeywords(
          self.mappintToSectionModels(keywords: localKeywords)
        )
      )
    } else {
      return .empty()
    }
  }

  private func mappintToSectionModels(keywords: [String]) -> [SearchRecentSectionModel] {
    guard keywords.isEmpty == false else { return [] }

    return [
      SearchRecentSectionModel(
        identity: .header,
        items: [
          .header
        ]
      ),
      SearchRecentSectionModel(
        identity: .keyword,
        items: keywords.enumerated().map {
          SearchRecentSectionModel.SectionItem.keyword(
            SearchRecentKeywordCell.ViewModel(
              title: $0.element,
              index: $0.offset
            )
          )
        }
      )
    ]
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
      Mutation.setKeywords(
        self.mappintToSectionModels(keywords: localKeywords)
      )
    )
  }

  private func removedKeyword(_ index: Int) -> Observable<Mutation> {
    var localKeywords: [String] = self.dependency
      .userDefaultService
      .value(forKey: .recentSearchKeyword) ?? []

    localKeywords.remove(at: index)
    self.dependency.userDefaultService.set(
      value: localKeywords,
      forKey: .recentSearchKeyword
    )

    return Observable<Mutation>.just(
      Mutation.setKeywords(
        self.mappintToSectionModels(keywords: localKeywords)
      )
    )
  }

  private func removeAllKeyword() -> Observable<Mutation> {
    self.dependency.userDefaultService.set(
      value: [],
      forKey: .recentSearchKeyword
    )

    return Observable<Mutation>.just(
      Mutation.setKeywords([])
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
    }
    return newState
  }
}
