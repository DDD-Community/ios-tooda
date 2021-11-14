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
  
  // MARK: Enum
  private enum Font {
    static let label = TextStyle.body(color: .gray1)
  }
  
  let titleLabel = UILabel().then {
    $0.textAlignment = .left
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  func bind(reactor: Reactor) {
    // State
    reactor.state
      .map { $0.name }
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] in
        self?.fetchTitle($0)
      }).disposed(by: self.disposeBag)
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
    
    self.contentView.addSubview(titleLabel)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(9)
      $0.centerY.equalToSuperview()
      $0.left.right.equalToSuperview().inset(18)
    }
  }
}

// MARK: - Extensions

extension StockItemCell {
  private func fetchTitle(_ name: String) {
    self.titleLabel.attributedText = name.styled(with: Font.label)
  }
}
