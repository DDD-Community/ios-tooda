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
import RxCocoa

class EmptyNoteStockCell: BaseTableViewCell, View {
  typealias Reactor = EmptyNoteStockCellReactor
  
  private enum Constants {
    static let baseColor: UIColor? = UIColor(type: .gray3)
  }

  var disposeBag: DisposeBag = DisposeBag()
  
  let containerView = UIView().then {
    $0.layer.borderColor = Constants.baseColor?.cgColor
    $0.layer.borderWidth = 1.0
    $0.layer.masksToBounds = true
  }
  
  let titleLabel = UILabel().then {
    $0.text = "종목 기록하기"
    $0.textColor = UIColor(type: .gray2)
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.sizeToFit()
  }
  
  let addStockButton = UIButton()
  
  let symbolImageVIew = UIImageView(image: UIImage(type: .iconCrossSymbol)).then {
    $0.contentMode = .scaleAspectFit
  }
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }

  func bind(reactor: Reactor) {

  }
  
  // MARK: Cell Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func configureUI() {
    super.configureUI()
    
    [containerView, addStockButton].forEach {
      self.contentView.addSubview($0)
    }
    
    [titleLabel, symbolImageVIew].forEach {
      self.containerView.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    addStockButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(12)
      $0.left.equalToSuperview().offset(14)
      $0.bottom.equalToSuperview().offset(-11)
    }
    
    symbolImageVIew.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel)
      $0.right.equalToSuperview().offset(-13)
      $0.size.equalTo(14)
    }
  }
}

// MARK: - Extensions

extension Reactive where Base: EmptyNoteStockCell {
  var didTapAddStock: ControlEvent<Void> {
    return self.base.addStockButton.rx.tap
  }
}
