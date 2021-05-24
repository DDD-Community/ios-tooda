//
//  NoteImageItemCell.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit

import SnapKit

class NoteImageItemCell: BaseCollectionViewCell, View {
  typealias Reactor = NoteImageItemCellReactor
  
  var disposeBag: DisposeBag = DisposeBag()
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
    
  func bind(reactor: Reactor) {
    
  }
}
