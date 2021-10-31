//
//  UIImage+Asset.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

enum AppImage: String {
  // Home
  case backBarButton = "back"
  case searchBarButton = "search"
  case settingBarButton = "setting"
  case noteBlue = "note-blue"
  case noteGray = "note-gray"
  case noteGreen = "note-green"
  case noteOrange = "note-orange"
  case notePurple = "note-purple"
  case noteRed = "note-red"
  case noteSkyblue = "note-skyblue"
  case noteYellow = "note-yellow"
  case stickerAngry = "sticker_angry"
  case stickerChicken = "sticker_chicken"
  case stickerWow = "sticker_wow"
  case stickerPencil = "sticker_pencil"
  case stickerSad = "sticker_sad"
  case stickerThinking = "sticker_thinking"

  case login = "login"
  case iconDownGray = "icon_down_gray"
  case iconArrowRightGray = "icon_arrow_right_gray"
  case closeBlack = "close_black"
  
  case closeButton = "close"
}

extension UIImage {
  
  convenience init?(type: AppImage) {
    self.init(named: type.rawValue)
  }
}
