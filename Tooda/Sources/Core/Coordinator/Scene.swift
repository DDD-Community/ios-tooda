//
//  Scene.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxRelay


enum Scene {
  case login
  case home
  case createNote
  case settings
  case addStock(completion: PublishRelay<NoteStock>)
  case search
  case noteList
  case searchRecent
  case stockRateInput(payload: StockRateInputReactor.Payload)
  case popUp(type: PopUpReactor.PopUpType)
  case searchResult
  case noteDetail
  
  var screenName: String {
    switch self {
    case .login:              return "login"
    case .home:               return "home"
    case .createNote:         return "createNote"
    case .settings:           return "settings"
    case .addStock:           return "addStock"
    case .search:             return "search"
    case .noteList:           return "noteList"
    case .searchRecent:       return "searchRecent"
    case .stockRateInput:     return "stockRateInput"
    case .popUp:              return "popUp"
    case .searchResult:       return "searchResult"
    case .noteDetail:         return "noteDetail"
    }
  }
}
