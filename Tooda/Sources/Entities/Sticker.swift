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
}
