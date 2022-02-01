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
  case iconAppleLogin = "icon_apple_logo"
  case iconDownGray = "icon_down_gray"
  case iconArrowRightGray = "icon_arrow_right_gray"
  case closeBlack = "close_black"
  case iconCancelBlack = "icon_cancel_black"
  case iconHistory14 = "icon_history_14"
  case iconLinkChain = "icon_link_chain"
  case iconSmileEmoji = "icon_smile_emoji"
  case iconNegativeEmoji = "icon_negative_emoji"
  case iconPositiveEmoji = "icon_positive_emoji"
  case iconCrossSymbol = "icon_cross_symbol"
  case iconImagePlaceHolder = "icon_image_placeHolder"
  
  case closeButton = "cancel"
  case moreButton = "more"
  case link = "link"

  // Emoji
  case emojiToodaGray = "emoji_tooda_gray"
  case addNewNoteButton = "add_new_note_btn"
}

extension UIImage {
  
  convenience init?(type: AppImage) {
    self.init(named: type.rawValue)
  }
}
