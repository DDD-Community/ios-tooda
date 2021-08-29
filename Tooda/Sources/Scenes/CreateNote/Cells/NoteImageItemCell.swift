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
  
  // TODO: ImageView로 변경 예정
  
  let containerView = UIView().then {
    $0.backgroundColor = UIColor(type: .gray1)
    $0.layer.cornerRadius = 8.0
    $0.layer.masksToBounds = true
  }
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
    
  func bind(reactor: Reactor) {
    
  }
  
  override func configureUI() {
    super.configureUI()
    
    [containerView].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
