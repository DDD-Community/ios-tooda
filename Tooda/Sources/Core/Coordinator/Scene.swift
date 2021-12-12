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
}
