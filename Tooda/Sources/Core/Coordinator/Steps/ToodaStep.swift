//
//  ToodaStep.swift
//  Tooda
//
//  Created by Lyine on 2022/03/26.
//

import Foundation
import RxFlow

enum ToodaStep: Step {
  // Global
  case alert(message: String)
  case dismiss
  
  // Login
  case loginIsRequired
  case loginIsCompleted
  
  // Home
  case homeIsRequired
}
