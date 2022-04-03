//
//  Step+asSample.swift
//  Tooda
//
//  Created by Lyine on 2022/03/26.
//

import Foundation

import RxFlow

extension Step {
  var asToodaStep: ToodaStep? {
    return self as? ToodaStep
  }
}
