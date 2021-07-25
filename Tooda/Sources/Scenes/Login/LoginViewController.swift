//
//  LoginViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/06/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

class LoginViewController: BaseViewController<LoginReactor> {
  
  // MARK: - Con(De)structor
  
  init(reactor: LoginReactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#file) deinitialized")
  }
}
