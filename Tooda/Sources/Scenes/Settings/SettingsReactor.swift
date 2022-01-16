//
//  SettingsReactor.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit
import RxSwift

final class SettingsReactor: Reactor {
  
  // MARK: Reactor
  
  enum Action {
    case didTapPlainSettingItem(index: Int)
    case didTapbackbutton
  }

  enum Mutation {
    
  }
  
  struct Dependency {
    let coordinator: AppCoordinatorType
  }
  
  struct State {
    let sectionModel: [SettingsSectionModel]
    
    static func generateInitialState() -> State {
      return State(sectionModel: [
        SettingsSectionModel(
          identity: .etc,
          items: [
            SettingsItem.plain(
              PlainSettingsInfo(
                title: "공지사항",
                url: URL(string: "https://bit.ly/3ncoDLu")
              )
            ),
            SettingsItem.plain(
              PlainSettingsInfo(
                title: "자주 묻는 질문",
                url: URL(string: "https://bit.ly/3r4LNoc")
              )
            ),
            SettingsItem.plain(
              PlainSettingsInfo(
                title: "약관 및 정책",
                url: URL(string: "https://bit.ly/3ratAFw")
              )
            )
          ]
        ) 
      ])
    }
  }
  
  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State.generateInitialState()
  }
  
  // MARK: Properties
  
  let dependency: Dependency
  
  let initialState: State
}

// MARK: - Mutate

extension SettingsReactor {
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case let .didTapPlainSettingItem(index):
      return presentSafariViewControllerMutation(index: index)
    case .didTapbackbutton:
      return dismissMutation()
    }
  }
  
  private func presentSafariViewControllerMutation(index: Int) -> Observable<Mutation> {
    if case let .plain(settingInfo) = initialState.sectionModel.first?.items[safe: index],
       let url = settingInfo.url {
      dependency.coordinator.transition(
        to: .inAppBrowser(url: url),
        using: .modal,
        animated: true,
        completion: nil
      )
    }
   
    return Observable<Mutation>.empty()
  }
  
  private func dismissMutation() -> Observable<Mutation> {
    dependency.coordinator.close(
      style: .pop,
      animated: true,
      completion: nil
    )
   
    return Observable<Mutation>.empty()
  }
}
