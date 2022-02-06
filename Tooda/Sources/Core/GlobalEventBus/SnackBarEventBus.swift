//
//  SnackBarEventBus.swift
//  Tooda
//
//  Created by 황재욱 on 2022/02/04.
//

import RxSwift

enum SnackBarEventBus {

  static let event = PublishSubject<SnackBarManager.SnackBarInfo>()
}
