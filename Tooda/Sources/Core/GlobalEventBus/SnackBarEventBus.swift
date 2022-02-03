//
//  SnackBarEventBus.swift
//  Tooda
//
//  Created by 황재욱 on 2022/02/04.
//

import RxSwift

enum SnackBarEventBus {
  
  typealias SnackBarInfo = (type: SnackBarType, title: String)

  static let event = PublishSubject<SnackBarInfo>()
}
