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
    case makeException(State.Exception)
  }
  
  struct State {
    enum Exception {
      case emptyNoteAlert
    }

    // Entities
    var notebooks: [NotebookMeta]
    var selectedNotobook: NotebookMeta?
    var selectedIndex: Int

    // ViewModels
    var notebookViewModels: [NotebookCell.ViewModel]
    var exception: Exception?
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
      selectedIndex: 0,
      notebookViewModels: [],
      exception: nil
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
      return self.pickDateMutation(date)

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

  private func loadMutation(date: Date = Date()) -> Observable<Mutation> {
    return self.dependency.service.request(
      NotebookAPI.meta(
        year: date.year
      )
    )
      .map([NotebookMeta].self)
      .catchAndReturn([])
      .asObservable()
      .map { Mutation.setNotebooks($0) }
  }

  private func pickDateMutation(_ date: Date) -> Observable<Mutation> {
    if date.year == Date().year {
      return Observable<Mutation>.just(
        .selectNotebook(
          notebookIndex: self.currentState.notebooks.firstIndex(where: {
            $0.year == date.year && $0.month == date.month
          })
        )
      )
    } else {
      return self.dependency.service.request(
        NotebookAPI.meta(
          year: date.year
        )
      )
        .map([NotebookMeta].self)
        .catchAndReturn([])
        .asObservable()
        .flatMap { books -> Observable<Mutation> in
          guard let index = books.firstIndex(where: { $0.month == date.month })
          else {
            return .just(.makeException(.emptyNoteAlert))
          }
          return Observable<Mutation>.concat([
            .just(.setNotebooks(books)),
            .just(.selectNotebook(notebookIndex: index))
          ])
        }
    }
  }
}


// MARK: - Reduce

extension HomeReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setNotebooks(metas):
      let addedMetas = self.addCurrentNotebookIfNeeded(metas: metas)
      newState.notebooks = addedMetas
      newState.notebookViewModels = self.mappingToNoteBooks(metas: addedMetas)
      newState.selectedNotobook = newState.notebooks[safe: 0]

    case let .selectNotebook(notebookIndex):
      guard let notebookIndex = notebookIndex,
            let notebook = state.notebooks[safe: notebookIndex]
      else {
        newState.exception = .emptyNoteAlert
        break
      }
      newState.selectedIndex = notebookIndex
      newState.selectedNotobook = notebook

    case let .makeException(exception):
      newState.exception = exception
    }

    return newState
  }

  private func addCurrentNotebookIfNeeded(metas: [NotebookMeta]) -> [NotebookMeta] {
    let currentDate = Date()
    let lastMonth = metas.last?.month ?? 0

    guard metas.last?.year ?? currentDate.year == currentDate.year,
          lastMonth != currentDate.month
    else {
      return metas
    }

    return metas.with {
      $0.append(NotebookMeta(
        year: currentDate.year,
        month: currentDate.month
      ))
    }
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
