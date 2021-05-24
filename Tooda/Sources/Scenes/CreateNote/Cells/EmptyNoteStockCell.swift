//
//  EmptyNoteStockCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit
import Then

class EmptyNoteStockCell: BaseTableViewCell, View {
  typealias Reactor = EmptyNoteStockCellReactor
  
  private enum Constants {
    static let baseColor: UIColor? = UIColor(type: .gray3)
  }

  var disposeBag: DisposeBag = DisposeBag()
  
  let containerView = UIView().then {
    $0.layer.borderColor = Constants.baseColor?.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 8.0
    $0.layer.masksToBounds = true
  }
  
  let titleLabel = UILabel().then {
    $0.text = "종목 기록하기"
    $0.textColor = UIColor(type: .gray2)
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.sizeToFit()
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
    
    [titleLabel].forEach {
      self.containerView.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.left.right.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.left.equalToSuperview().offset(14)
      $0.bottom.equalToSuperview().offset(-11)
    }
  }
}
