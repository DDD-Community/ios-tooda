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
  }

  enum Mutation {
    case setNotebooks([NotebookMeta])
  }
  
  struct State {
    var date: Date
    var notebooks: [NotebookCell.ViewModel]
  }


  // MARK: Constants

  private enum Const {
    static let notebookImagesCount: Int = 7
  }


  // MARK: Properties

  private let dependency: Dependency

  private var notebookImages: [UIImage?] = []
  
  let initialState: State = State(
    date: Date(),
    notebooks: []
  )
  
  
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
  }
}


// MARK: - Mutate

extension HomeReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .load:
      return self.loadMutation()
    }
  }

  private func loadMutation() -> Observable<Mutation> {
    return Observable.just(
      Mutation.setNotebooks([
        NotebookMeta(
          year: 2021,
          month: 1,
          noteCount: 10,
          createdAt: Date(),
          updatedAt: Date()
        ),
        NotebookMeta(
          year: 2021,
          month: 1,
          noteCount: 10,
          createdAt: Date(),
          updatedAt: Date()
        ),
        NotebookMeta(
          year: 2021,
          month: 1,
          noteCount: 10,
          createdAt: Date(),
          updatedAt: Date()
        )
      ])
    )
    // TODO: create 되면 추가할 예정
//    return self.dependency.service.request(NotebookAPI.meta(year: self.currentState.date.year))
//      .map([NotebookMeta].self)
//      .asObservable()
//      .map { Mutation.setNotebooks($0) }
  }
}


// MARK: - Mutate

extension HomeReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setNotebooks(metas):
      newState.notebooks = self.mappingToNoteBooks(metas: metas)
    }

    return newState
  }

  private func mappingToNoteBooks(metas: [NotebookMeta]) -> [NotebookCell.ViewModel] {
    return metas.enumerated().map { (index, item) in
      let day = Calendar.current.dateComponents([.day], from: item.updatedAt, to: Date()).day
      let historyDate: String? = {
        guard let day = day, day > 0 else { return nil }
        return "\(day)"
      }()

      let backgroundImage: UIImage? = self.notebookImages[index % Const.notebookImagesCount]

      return NotebookCell.ViewModel(
        month: "\(item.month)",
        backgroundImage: backgroundImage,
        historyDate: historyDate,
      )
    }
  }
}
