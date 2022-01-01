//
//  Sticker.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/07/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

enum Sticker: String, Codable {
  case sad = "SAD"
  case wow = "OMG"
  case angry = "ANGRY"
  case thinking = "THINKING"
  case chicken = "CHICKEN"
  case pencil = "PENCIL"
}


extension Sticker {

  var image: UIImage? {
    switch self {
    case .sad:
      return UIImage(type: .stickerSad)

    case .wow:
      return UIImage(type: .stickerWow)

    case .angry:
      return UIImage(type: .stickerAngry)

    case .thinking:
      return UIImage(type: .stickerThinking)

    case .chicken:
      return UIImage(type: .stickerThinking)

    case .pencil:
      return UIImage(type: .stickerPencil)
    }
  }
  
  var optionTitle: String {
    switch self {
    case .sad:
      return "아... 탈출각"

    case .wow:
      return "추가 매수 가즈아~"

    case .angry:
      return "!@#@%!*%*"

    case .thinking:
      return "그럭저럭 괜찮아"

    case .chicken:
      return "오늘은 치킨데이"

    case .pencil:
      return "투자 정보를 줍줍"
    }
  }
}
