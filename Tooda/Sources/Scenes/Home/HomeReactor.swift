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
    let noteEventBus: Observable<NoteEventBus.Event>
  }


  // MARK: Reactor
  
  enum Action {
    case load
    case paging(index: Int)
    case pickDate(_ date: Date)
    case didTapNotebook(index: Int)

    // routing
    case pushSearch
    case pushSettings
    case presentCreateNote(dateString: String)
  }

  enum Mutation {
    case setNotebooks([NotebookMeta])
    case selectNotebook(notebookIndex: Int?)
    case makeException(State.Exception)
    case setLoading(Bool)
  }
  
  struct State {
    enum Exception: Int, Equatable {
      case emptyNoteAlert
    }

    // Entities
    var notebooks: [NotebookMeta]
    var selectedNotobook: NotebookMeta?
    var selectedIndex: Int?

    // ViewModels
    var notebookViewModels: [NotebookCell.ViewModel]
    var exception: Exception?
    var isLoading: Bool
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
      selectedIndex: nil,
      notebookViewModels: [],
      exception: nil,
      isLoading: false
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
      return Observable<Mutation>.concat([
        .just(Mutation.setLoading(true)),
        self.loadMutation()
      ])

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

    case let .didTapNotebook(notebookIndex):
      self.didTapNotebook(index: notebookIndex)
      return Observable<Mutation>.empty()
    }
  }

  private func loadMutation(date: Date = Date()) -> Observable<Mutation> {
    return self.dependency.service.request(
      NotebookAPI.meta(
        year: date.year
      )
    )
      .toodaMap([NotebookMeta].self)
      .catchAndReturn([])
      .asObservable()
      .flatMap {
        return Observable<Mutation>.concat([
          .just(.setLoading(false)),
          .just(.setNotebooks($0))
        ])
      }
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
      return Observable<Mutation>.concat([
        .just(.setLoading(true)),
        self.dependency.service.request(
          NotebookAPI.meta(
            year: date.year
          )
        )
          .toodaMap([NotebookMeta].self)
          .catchAndReturn([])
          .asObservable()
          .flatMap { books -> Observable<Mutation> in
            guard let index = books.firstIndex(where: { $0.month == date.month })
            else {
              return Observable<Mutation>.concat([
                .just(.setLoading(false)),
                .just(.makeException(.emptyNoteAlert))
              ])
            }
            return Observable<Mutation>.concat([
              .just(.setLoading(false)),
              .just(.setNotebooks(books)),
              .just(.selectNotebook(notebookIndex: index))
            ])
          }
      ])

    }
  }
}


// MARK: - Transform

extension HomeReactor {

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(
      mutation,
      self.dependency.noteEventBus
        .flatMap { event -> Observable<Mutation> in
          switch event {
          case let .createNote(note):
            return self.createNoteEventBusMutaion(note)

          case let .editNode(note):
            return self.editNoteEventBusMutaion(note)

          case let .deleteNote(note):
            return self.deleteNoteEventBusMutation(note)
          }
        }
    )
  }

  private func createNoteEventBusMutaion(_ note: Note) -> Observable<Mutation> {
    guard let newNoteYear = note.createdAt?.year,
          let newNoteMonth = note.createdAt?.month else { return .empty() }

    if self.currentState.notebooks.isEmpty {
      return .just(
        .setNotebooks([
          .init(
            year: newNoteYear,
            month: newNoteMonth,
            noteCount: 1,
            createdAt: note.createdAt,
            updatedAt: note.updatedAt,
            stickers: note.sticker == nil ? [] : [note.sticker!]
          )
        ])
      )
    }

    if let index = self.currentState.notebooks.firstIndex(where: {
      $0.year == newNoteYear && $0.month == newNoteMonth
    }) {
      var notebooks = self.currentState.notebooks
      notebooks[index].noteCount += 1
      notebooks[index].updatedAt = note.updatedAt
      if notebooks[index].stickers.count < 3,
         let sticker = note.sticker {
        notebooks[index].stickers.append(sticker)
      }
      return .just(
        .setNotebooks(notebooks)
      )
    }

    // NOTE: 오늘만 생성했을 때만 가능한 로직
    var notebooks = self.currentState.notebooks
    notebooks.append(.init(
      year: newNoteYear,
      month: newNoteMonth,
      noteCount: 1,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      stickers: note.sticker == nil ? [] : [note.sticker!]
    ))
    return .just(
      .setNotebooks(notebooks)
    )
  }

  private func editNoteEventBusMutaion(_ note: Note) -> Observable<Mutation> {
    guard let index = self.currentState.notebooks.firstIndex(where: {
      $0.year == note.createdAt?.year && $0.month == note.createdAt?.month
    }) else { return .empty() }

    var notebooks = self.currentState.notebooks
    notebooks[index].updatedAt = note.updatedAt

    return .just(
      .setNotebooks(notebooks)
    )
  }

  private func deleteNoteEventBusMutation(_ note: Note) -> Observable<Mutation> {
    guard let index = self.currentState.notebooks.firstIndex(where: {
      $0.year == note.createdAt?.year && $0.month == note.createdAt?.month
    }) else { return .empty() }

    var notebooks = self.currentState.notebooks
    if notebooks[index].noteCount >= 2 {
      notebooks[index].noteCount -= 1
      notebooks[index].updatedAt = Date()
    } else {
      notebooks.remove(at: index)
    }

    return .just(
      .setNotebooks(notebooks)
    )
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

    case let .setLoading(isLoading):
      newState.isLoading = isLoading
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
          let historyDate: String? = {
            guard let updateAt = item.updatedAt,
                  let day = Calendar.current.dateComponents(
                    [.day],
                    from: updateAt,
                    to: Date()
                  ).day,
                  day >= 0
            else {
              return nil
            }
            guard day > 0 else { return "오늘 살펴봤어요." }
            return "\(day)일 전에 살펴봤어요"
          }()

          let isPlaceholder = item.updatedAt == nil

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

  private func didTapNotebook(index: Int) {
    guard let selectedNotebook = self.currentState.notebooks[safe: index] else {
      return
    }
    if selectedNotebook.updatedAt == nil {
      self.presentCreateNote(nil)
    } else {
      self.presentNoteList(notebook: selectedNotebook)
    }
  }

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
  
  private func presentCreateNote(_ dateString: String?) {
    let todayString = dateString ?? Date().string(.dot)
    self.dependency.coordinator.transition(
      to: .createNote(dateString: todayString),
      using: .modal,
      animated: true,
      completion: nil
    )
  }

  private func presentNoteList(notebook: NotebookMeta) {
    self.dependency.coordinator.transition(
      to: .noteList(payload: .init(
        year: notebook.year,
        month: notebook.month
      )),
      using: .modal,
      animated: true,
      completion: nil
    )
  }
}
