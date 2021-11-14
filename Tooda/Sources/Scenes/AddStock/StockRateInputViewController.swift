//
//  StockRateInputViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then
  // ReactorViewController

class ReactorViewController: BaseViewController<StockRateInputReactor> {
  typealias Reactor = StockRateInputReactor
  
  init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  override func configureUI() {
    super.configureUI()
  }
  
  override func configureConstraints() {
    super.configureConstraints()
  }
  
  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)
  }
}
