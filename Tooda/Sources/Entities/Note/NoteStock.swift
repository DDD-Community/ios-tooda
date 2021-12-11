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
	case rise
	case even
	case fall
}

extension StockChangeState {
  var titleText: String {
    switch self {
      case .rise:
        return "+ 상승"
      case .even:
        return "유지"
      case .fall:
        return "- 하락"
    }
  }
    
  var titleColor: UIColor {
    switch self {
      case .rise:
        return UIColor.subRed
      case .even:
        return UIColor.gray2
      case .fall:
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
