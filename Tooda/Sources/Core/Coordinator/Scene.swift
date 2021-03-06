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
  case createNote(dateString: String, routeToDetailRelay: PublishRelay<Int>?)
  case modifyNote(dateString: String, note: NoteRequestDTO)
  case settings
  case addStock(completion: PublishRelay<NoteStock>)
  case search
  case noteList(payload: NoteListReactor.Payload)
  case searchRecent
  case stockRateInput(payload: StockRateInputReactor.Payload, editMode: StockRateInputViewController.EditMode = .input)
  case popUp(type: PopUpReactor.PopUpType)
  case searchResult
  case noteDetail(payload: NoteDetailReactor.Payload)
  case inAppBrowser(url: URL)
  
  var screenName: String {
    switch self {
    case .login:              return "login"
    case .home:               return "home"
    case .createNote:         return "createNote"
    case .modifyNote:         return "modifyNote"
    case .settings:           return "settings"
    case .addStock:           return "addStock"
    case .search:             return "search"
    case .noteList:           return "noteList"
    case .searchRecent:       return "searchRecent"
    case .stockRateInput:     return "stockRateInput"
    case .popUp:              return "popUp"
    case .searchResult:       return "searchResult"
    case .noteDetail:         return "noteDetail"
    case .inAppBrowser:       return "inAppBrowser"
    }
  }
}
