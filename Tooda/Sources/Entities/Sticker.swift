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
  case omg = "OMG"
  case angry = "ANGRY"
  case thinking = "THINKING"
  case chicken = "CHICKEN"
  case pencil = "PENCIL"
}


extension Sticker {

  var image: UIImage? {
    switch self {
    case .sad:
      return UIImage(type: .sad)

    case .omg:
      return UIImage(type: .omg)

    case .angry:
      return UIImage(type: .angry)

    case .thinking:
      return UIImage(type: .thinking)

    case .chicken:
      return UIImage(type: .chicken)

    case .pencil:
      return UIImage(type: .pencil)
    }
  }
}
