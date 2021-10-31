//
//  AddStockViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/10/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import Then

final class AddStockViewController: BaseViewController<AddStockReactor> {
  
  typealias Reactor = AddStockReactor
  
  // MARK: Constants
  
  private enum Font {
    
  }
  
  private enum Metric {
    
  }
  
  // MARK: UI Components
  
  // MARK: Initialzier
  
  init(reactor: Reactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#file) deinitialized")
  }
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: Bind
  
  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)
    
    // Action
    
    // State
  }
  
  // MARK: SetupUI
  
  override func configureUI() {
    super.configureUI()
  }
  
  override func configureConstraints() {
    super.configureConstraints()
  }
}
