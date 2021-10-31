//
//  StockItemCell.swift
//  Tooda
//
//  Created by Lyine on 2021/10/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit

class StockItemCell: BaseTableViewCell, View {
  typealias Reactor = StockItemCellReactor
  
  var disposeBag: DisposeBag = DisposeBag()
  
  func bind(reactor: Reactor) {
    
  }
  
  // MARK: Cell Life Cycle
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func configureUI() {
    super.configureUI()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
  }
}
