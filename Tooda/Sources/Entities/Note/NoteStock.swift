//
//  NoteStock.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import UIKit

enum StockChangeState: String, Codable {
	case RISE
	case EVEN
	case FALL
}

extension StockChangeState {
  var titleText: String {
    switch self {
      case .RISE:
        return "+ 상승"
      case .EVEN:
        return "유지"
      case .FALL:
        return "- 하락"
    }
  }
    
  var titleColor: UIColor {
    switch self {
      case .RISE:
        return UIColor.subRed
      case .EVEN:
        return UIColor.gray2
      case .FALL:
        return UIColor.subBlue
    }
  }
}

struct NoteStock: Codable {
	var id: Int
	var name: String
	var change: StockChangeState?
	var changeRate: Float?
}
