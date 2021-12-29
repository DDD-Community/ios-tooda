//
//  PopUpReactor.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import Then
import RxRelay
import RxCocoa

final class PopUpReactor: Reactor {
  
  // MARK: - Constants
  
  enum PopUpType {
    case list(PublishRelay<Sticker>)
    case textInput(PublishRelay<String>)
  }
  
  // MARK: Reactor
  
  enum Action {
    case didSelectOption(Int)
  }

  enum Mutation {

  }
  
  struct Dependency {
    let type: PopUpType
    let coordinator: AppCoordinatorType
  }
  
  struct State {
    let emojiOptionsSectionModels: [EmojiOptionsSectionModel]
    
    static func generateInitialState() -> State {
      return State(
        emojiOptionsSectionModels: [
          EmojiOptionsSectionModel(
            items: [
              .wow,
              .angry,
              .chicken,
              .pencil,
              .thinking,
              .sad
            ]
          )
        ]
      )
    }
  }

  // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State.generateInitialState()
  }
}

// MARK: - Mutate

extension PopUpReactor {
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didSelectOption(index):
      return didSelectOption(index: index)
    }
  }
}

// MARK: - Private Functions

extension PopUpReactor {

  private func didSelectOption(index: Int) -> Observable<Mutation> {
    if let selectedEmoji = initialState.emojiOptionsSectionModels.first?.items[safe: index] {
      
      if case let .list(optionPublishRelay) = dependency.type {
        optionPublishRelay.accept(selectedEmoji)
      }
    }
    
    dependency.coordinator.close(
      style: .dismiss,
      animated: false,
      completion: nil
    )
    
    return Observable<Mutation>.empty()
  }
}
