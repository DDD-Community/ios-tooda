//
//  BaseAlertAction.swift
//  Tooda
//
//  Created by lyine on 2021/05/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

enum BaseAlertAction: AlertActionType {
  case ok
  case cancel
  
  var title: String? {
    switch self {
      case .ok: return "확인"
      case .cancel: return "취소"
    }
  }
  
  var style: UIAlertAction.Style {
    switch self {
      case .ok: return .default
      case .cancel: return .default
    }
  }
}
