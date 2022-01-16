//
//  HomeReactor.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class HomeReactor: Reactor {

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
  }


  // MARK: Reactor
  
  enum Action {
    case load
    case paging(index: Int)
    case pickDate(_ date: Date)

    // routing
    case pushSearch
    case pushSettings
    case presentCreateNote(dateString: String)
    case presentNotelist(notebookIndex: Int)
  }

  enum Mutation {
    case setNotebooks([NotebookMeta])
    case selectNotebook(notebookIndex: Int?)
  }
  
  struct State {
    // Entities
    var notebooks: [NotebookMeta]
    var selectedNotobook: NotebookMeta?
    var selectedIndex: Int?

    // ViewModels
    var notebookViewModels: [NotebookCell.ViewModel]
  }

  // MARK: Constants

  private enum Const {
    static let notebookImagesCount: Int = 7
  }


  // MARK: Properties

  private let dependency: Dependency

  private var notebookImages: [UIImage?] = []
  private var placeholderNotebookImage: UIImage?
  
  let initialState: State = {
    let currentDate = Date()

    return State(
      notebooks: [],
      selectedNotobook: nil,
      notebookViewModels: []
    )
  }()

  init(dependency: Dependency) {
    self.dependency = dependency
    self.configureNotebookImages()
  }

  private func configureNotebookImages() {
    self.notebookImages = [
      UIImage(type: .noteRed),
      UIImage(type: .noteGreen),
      UIImage(type: .noteOrange),
      UIImage(type: .notePurple),
      UIImage(type: .noteRed),
      UIImage(type: .noteSkyblue),
      UIImage(type: .noteYellow)
    ]

    self.placeholderNotebookImage = UIImage(type: .noteGray)
  }
}


// MARK: - Mutate

extension HomeReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .load:
      return self.loadMutation()

    case let .paging(index):
      return Observable<Mutation>.just(.selectNotebook(notebookIndex: index))

    case let .pickDate(date):
      return Observable<Mutation>.just(
        .selectNotebook(
          notebookIndex: self.currentState.notebooks.firstIndex(where: {
            $0.year == date.year && $0.month == date.month
          })
        )
      )

    case .pushSearch:
      self.pushSearch()
      return Observable<Mutation>.empty()

    case .pushSettings:
      pushSettings()
      return Observable<Mutation>.empty()

    case .presentCreateNote(let today):
      presentCreateNote(today)
      return Observable<Mutation>.empty()

    case let .presentNotelist(notebookIndex):
      self.presentNoteList(index: notebookIndex)
      return Observable<Mutation>.empty()
    }
  }

  private func loadMutation() -> Observable<Mutation> {
    return self.dependency.service.request(
      NotebookAPI.meta(
        year: Date().year   // TODO: 데이터 받는걸로 변경 예정
      )
    )
      .map([NotebookMeta].self)
      .catchAndReturn([])
      .asObservable()
      .map { Mutation.setNotebooks($0) }
  }
}


// MARK: - Reduce

extension HomeReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setNotebooks(metas):
      newState.notebooks = metas
      newState.notebookViewModels = self.mappingToNoteBooks(metas: metas)

    case let .selectNotebook(notebookIndex):
      guard let notebookIndex = notebookIndex,
            let notebook = state.notebooks[safe: notebookIndex] else { break }
      newState.selectedIndex = notebookIndex
      newState.selectedNotobook = notebook
    }

    return newState
  }

  private func mappingToNoteBooks(metas: [NotebookMeta]) -> [NotebookCell.ViewModel] {
    var viewModels: [NotebookCell.ViewModel] = []
    viewModels.append(
      contentsOf:
        metas.enumerated().map { (index, item) in
          let day = Calendar.current.dateComponents(
            [.day],
            from: item.updatedAt ?? Date(),
            to: Date()
          ).day

          let historyDate: String? = {
            guard let day = day, day > 0 else { return nil }
            return "\(day)"
          }()

          let isPlaceholder = item.createdAt == nil

          let backgroundImage: UIImage? = {
            if isPlaceholder {
              return self.placeholderNotebookImage
            }
            return self.notebookImages[index % Const.notebookImagesCount]
          }()

          return NotebookCell.ViewModel(
            month: "\(item.month)",
            backgroundImage: backgroundImage,
            historyDate: historyDate,
            stickers: item.stickers.map { $0.image },
            isPlaceholder: isPlaceholder
          )
        }
    )

    return viewModels
  }
}


// MARK: - Routing

extension HomeReactor {

  private func pushSearch() {
    self.dependency.coordinator.transition(
      to: .search,
      using: .push,
      animated: true,
      completion: nil
    )
  }
  
  private func pushSettings() {
    self.dependency.coordinator.transition(
      to: .settings,
      using: .push,
      animated: true,
      completion: nil
    )
  }
  
  private func presentCreateNote(_ dateString: String) {
    self.dependency.coordinator.transition(
      to: .createNote(dateString: dateString),
      using: .modal,
      animated: true,
      completion: nil
    )
  }

  private func presentNoteList(index: Int) {
    guard let selectedNotebook = self.currentState.notebooks[safe: index] else { return }
    self.dependency.coordinator.transition(
      to: .noteList(payload: .init(
        year: selectedNotebook.year,
        month: selectedNotebook.month
      )),
      using: .modal,
      animated: true,
      completion: nil
    )
  }
}
