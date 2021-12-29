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
  
  // MARK: - Constants
  
  private enum Font {
    static let title = TextStyle.subTitle(color: .gray1)
  }
  
  // MARK: - Properties
  
  lazy var disposeBag = DisposeBag()
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.textAlignment = .center
  }
  
  private let dismissButton = UIButton(type: .system)
  
  private let bottomButton = BaseButton(width: nil, height: 48)
  
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
      $0.trailing.equalToSuperview().inset(26)
      $0.top.equalToSuperview().inset(24)
      $0.width.height.equalTo(12)
    }
    
    dismissButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(21)
    }
  }
  
  func insertContentViewLayout(view: UIView, margin: UIEdgeInsets) {
    addSubview(view)
    view.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(margin.top)
      $0.leading.equalToSuperview().inset(margin.left)
      $0.trailing.equalToSuperview().inset(margin.right)
      $0.bottom.equalToSuperview().inset(margin.bottom)
    }
  }
}
