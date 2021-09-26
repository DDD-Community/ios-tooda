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
    
  }

  enum Mutation {
    
  }
  
  struct Dependency {
    
  }
  
  struct State {
    let sectionModel: [SettingsSectionModel]
    
    static func generateInitialState() -> State {
      return State(sectionModel: [
        SettingsSectionModel(
          identity: .notification,
          items: [
            SettingsItem.interactive(
              InteractiveSettingsInfo(
                title: "푸시 알림",
                description: "매일 다이어리를 쓰도록 도와줍니다",
                isOn: false
              ))
          ]),
        SettingsSectionModel(
          identity: .etc,
          items: [
            SettingsItem.plain(
              PlainSettingsInfo(title: "공지사항")
            ),
            SettingsItem.plain(
              PlainSettingsInfo(title: "자주 묻는 질문")
            ),
            SettingsItem.plain(
              PlainSettingsInfo(title: "약관 및 정책")
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
