//
//  BaseViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import ReactorKit

class BaseViewController<T: Reactor>: UIViewController, View {
  typealias Reactor = T
  
  var disposeBag: DisposeBag = DisposeBag()
  
  func bind(reactor: T) {}
}
