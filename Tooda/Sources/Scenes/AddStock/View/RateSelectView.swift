//
//  RateSelectView.swift
//  Tooda
//
//  Created by Lyine on 2021/11/26.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class RateSelectView: UIView {
  
  private(set) var didSetupConstraints = false
  
  var disposeBag: DisposeBag = DisposeBag()
  
  private enum Metric {
    static let buttonWidth: CGFloat = 72.0
  }
  
  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.alignment = .fill
    $0.spacing = 8.0
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let riseButton = RateButton(stockState: .RISE)
  private let evenButton = RateButton(stockState: .EVEN)
  private let fallButton = RateButton(stockState: .FALL)
  
  var buttons: [RateButton] {
    return [self.riseButton, self.evenButton, self.fallButton]
  }
  
  override init(frame: CGRect) {
    defer {
      configureUI()
    }
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateConstraints()
  }
  
  private func configureUI() {
    self.addSubviews(stackView)
    
    buttons.forEach {
      self.stackView.addArrangedSubview($0)
    }
  }
  
  private func setupConstraints() {
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    riseButton.snp.makeConstraints {
      $0.width.equalTo(Metric.buttonWidth)
    }
    
    evenButton.snp.makeConstraints {
      $0.width.equalTo(Metric.buttonWidth)
    }
    
    fallButton.snp.makeConstraints {
      $0.width.equalTo(Metric.buttonWidth)
    }
  }
}

  // MARK: - Extension

extension Reactive where Base: RateSelectView {
  var didSelectedChanged: Observable<StockChangeState> {
    let selectedButton = Observable.from(
      self.base.buttons.map { button in button.rx.tap.map { button.stockState } }
    )
      .merge()
    
    self.base.buttons.reduce(Disposables.create()) { disposable, button in
      let subscription = selectedButton
        .map { $0 == button.stockState }
        .bind(to: button.rx.isSelected)
      return Disposables.create(disposable, subscription)
    }
    .disposed(by: self.base.disposeBag)
    
    return selectedButton.asObservable()
  }
}
