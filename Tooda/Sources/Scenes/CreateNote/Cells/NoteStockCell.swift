//
//  NoteStockCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit

class NoteStockCell: BaseTableViewCell, View {
  typealias Reactor = NoteStockCellReactor

  var disposeBag: DisposeBag = DisposeBag()
  
  private enum Font {
    static let title = TextStyle.body(color: .gray1)
  }
  
    // MARK: UI Properties
  
  private let containerView = UIView().then {
    $0.layer.borderColor = UIColor.gray4.cgColor
    $0.layer.borderWidth = 1.0
  }
  
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 1
  }
  
  private let rateStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fill
    $0.spacing = 6.0
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let rateIndicatorView = UIView().then {
    $0.layer.borderWidth = 1.0
    $0.layer.cornerRadius = 12.0
    $0.clipsToBounds = true
  }
  
  private let rateIndicatorLabel = UILabel()
  
  private let ratePercentLabel = UILabel().then {
    $0.numberOfLines = 1
  }
  
  // MARK: Cell Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  func bind(reactor: Reactor) {
    reactor.state.map { $0.payload }
    .subscribeOn(MainScheduler.instance)
    .subscribe(onNext: { [weak self] in
      self?.configureCell($0)
    })
    .disposed(by: self.disposeBag)
  }
  
  func configure(with reactor: Reactor) {
    super.configure()
    
    self.reactor = reactor
  }
  
  override func configureUI() {
    super.configureUI()
    
    self.contentView.addSubviews(containerView)
    
    self.containerView.addSubviews(self.titleLabel, self.rateStackView)
    
    self.rateStackView.addArrangedSubview(self.rateIndicatorView)
    self.rateStackView.addArrangedSubview(self.ratePercentLabel)
    
    self.rateIndicatorView.addSubview(self.rateIndicatorLabel)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    self.containerView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    self.titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(11)
      $0.leading.equalToSuperview().offset(14)
      $0.bottom.equalToSuperview().offset(-14)
    }
    
    self.rateStackView.snp.makeConstraints {
      $0.centerY.equalTo(self.titleLabel)
      $0.trailing.equalToSuperview().offset(-14)
      $0.leading.greaterThanOrEqualTo(self.titleLabel.snp.trailing).offset(14)
    }
    
    self.rateIndicatorLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 3, left: 7, bottom: 2, right: 7))
    }
  }
}

  // MARK: - Extensions

extension NoteStockCell {
  private func configureCell(_ payload: Reactor.Payload) {
    self.titleLabel.attributedText = payload.name.styled(with: Font.title)
    
    let rateValue = "\(payload.rate)%"
    
    self.ratePercentLabel.attributedText = rateValue.styled(with: TextStyle.bodyBold(color: payload.state.titleColor))
    
    var attributeText = NSAttributedString()
    var color: UIColor
    
    switch payload.state {
      case .rise:
        color = UIColor.subRed
        attributeText = "상승".styled(with: TextStyle.captionBold(color: color))
      case .even:
        color = UIColor.gray1
        attributeText = "유지".styled(with: TextStyle.captionBold(color: color))
      case .fall:
        color = UIColor.subBlue
        attributeText = "하락".styled(with: TextStyle.captionBold(color: color))
    }
    
    self.rateIndicatorLabel.attributedText = attributeText
    self.rateIndicatorView.layer.borderColor = color.cgColor
  }
}
