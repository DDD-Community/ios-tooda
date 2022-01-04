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
    case didTapBottonButton
    case didAddTextInput(String)
    case dismiss
  }

  enum Mutation {
    case setSelectedOption(Sticker)
  }
  
  struct Dependency {
    let type: PopUpType
    let coordinator: AppCoordinatorType
  }
  
  struct State {
    let emojiOptionsSectionModels: [EmojiOptionsSectionModel]
    var selectedSticker: Sticker?
    
    static func generateInitialState() -> State {
      return State(
        emojiOptionsSectionModels: [
          EmojiOptionsSectionModel(
            items: [
              .wow,
              .thinking,
              .sad,
              .angry,
              .chicken,
              .pencil
            ]
          )
        ],
        selectedSticker: nil
      )
    }
  }

  // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
  
  // MARK: - Con(De)structor
  
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
      return didSelectOptionMutation(index: index)
    case .didTapBottonButton:
      return didTapBottonButtonMutation()
    case let .didAddTextInput(textInput):
      return didAddTextInputMutation(textInput: textInput)
    case .dismiss:
      return dismissMutation()
    }
  }
}

// MARK: - Private Functions

extension PopUpReactor {
  private func didSelectOptionMutation(index: Int) -> Observable<Mutation> {
    guard let selectedEmoji = initialState.emojiOptionsSectionModels.first?.items[safe: index] else { return Observable<Mutation>.empty() }
    
    return Observable<Mutation>.just(.setSelectedOption(selectedEmoji))
  }
  
  private func dismissMutation() -> Observable<Mutation> {
    
    dependency.coordinator.close(
      style: .dismiss,
      animated: false,
      completion: nil
    )
    
    return Observable<Mutation>.empty()
  }
  
  private func didTapBottonButtonMutation() -> Observable<Mutation> {
    if let selectedSticker = currentState.selectedSticker,
      case let .list(relay) = dependency.type {
        relay.accept(selectedSticker)
    }
    
    dependency.coordinator.close(
      style: .dismiss,
      animated: false,
      completion: nil
    )
    
    return Observable<Mutation>.empty()
  }
  
  private func didAddTextInputMutation(textInput: String) -> Observable<Mutation> {
    if case let .textInput(relay) = dependency.type {
        relay.accept(textInput)
    }
    
    dependency.coordinator.close(
      style: .dismiss,
      animated: false,
      completion: nil
    )
    
    return Observable<Mutation>.empty()
  }
}

// MARK: - Reduce

extension PopUpReactor {
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setSelectedOption(sticker):
      newState.selectedSticker = sticker
    }

    return newState
  }
}
