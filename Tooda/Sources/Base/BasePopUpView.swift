//
//  BasePopUpView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxSwift

class BasePopUpView: UIView {
  
  // MARK: - RxStream
  
  lazy var didTapDismissButton = dismissButton.rx.tap.asObservable()
  
  lazy var didTapBottomButton = bottomButton.rx.tap.asObservable()
  
  // MARK: - Properties
  
  lazy var disposeBag = DisposeBag()
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  private let dismissButton = UIButton(type: .system).then {
    $0.setImage(UIImage(type: .iconCancelBlack), for: .normal)
    $0.tintColor = .black
  }
  
  private let bottomButton = BaseButton(width: nil, height: 48)
  
  // MARK: - Internal methods
  
  func setTitle(with title: String, style: String.Style) {
    titleLabel.attributedText = title.styled(with: style)
  }
  
  func setBottomButtonTitle(with title: String, style: String.Style) {
    bottomButton.setButtonTitle(with: title, style: style)
  }
  
  func setupUI() {
    self.do {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 12
      $0.addSubviews(
        titleLabel,
        dismissButton,
        bottomButton
      )
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20)
      $0.leading.trailing.equalToSuperview().inset(40)
    }
    
    dismissButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.top.equalToSuperview().inset(18)
      $0.width.height.equalTo(24)
    }
    
    bottomButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(21)
      $0.bottom.equalToSuperview().inset(30)
    }
  }
  
  func insertContentViewLayout(view: UIView, margin: UIEdgeInsets) {
    addSubview(view)
    view.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(margin.top)
      $0.leading.equalToSuperview().inset(margin.left)
      $0.trailing.equalToSuperview().inset(margin.right)
      $0.bottom.equalTo(bottomButton.snp.top).offset(-margin.bottom)
    }
  }
  
  func setBottomButtonOnOff(isOn: Bool) {
    bottomButton.setOnOff(isOn: isOn)
  }
}
