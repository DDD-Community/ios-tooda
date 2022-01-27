//
//  BaseButton.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class BaseButton: UIButton {
  
  enum ButtonType {
    case base
    case appleLogin
  }
  
  private let width: CGFloat?
  private let height: CGFloat
  
  private let disposeBag = DisposeBag()

  override var buttonType: UIButton.ButtonType {
    return .system
  }
  
  init(width: CGFloat?, height: CGFloat, type: ButtonType) {
    self.width = width
    self.height = height
    super.init(frame: .zero)
    baseConfigure(type: type)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func baseConfigure(type: ButtonType) {
    
    switch type {
    case .base:
      backgroundColor = UIColor.mainGreen
    case .appleLogin:
      backgroundColor = UIColor.black
      setImage(
        UIImage(type: .iconAppleLogin),
        for: .normal
      )
    }
    
    self.do {
      $0.layer.cornerRadius = CGFloat(height / 2)
      $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
      $0.layer.shadowOffset = CGSize(width: 0, height: 8)
      $0.layer.shadowOpacity = 1
      $0.layer.shadowRadius = 12
    }
    
    if let width = width {
      snp.makeConstraints {
        $0.width.equalTo(width)
        $0.height.equalTo(height)
      }
    } else {
      snp.makeConstraints {
        $0.height.equalTo(height)
      }
    }
    
    Driver<Void>.merge(
      rx.controlEvent(.touchUpOutside).asDriver(),
      rx.controlEvent(.touchUpInside).asDriver()
    )
    .drive { [weak self] _ in
      self?.layer.shadowOpacity = 1
    }
    .disposed(by: disposeBag)
    
    rx.controlEvent(.touchDown)
      .asDriver()
      .drive { [weak self] _ in
        self?.layer.shadowOpacity = 0
      }
      .disposed(by: disposeBag)
  }
  
  func setButtonTitle(with title: String, style: String.Style) {
    setAttributedTitle(
      title.styled(with: style),
      for: .normal
    )
  }
  
  func setOnOff(isOn: Bool) {
    if isOn {
      backgroundColor = UIColor.mainGreen
      layer.shadowOpacity = 1
      isUserInteractionEnabled = true
    } else {
      backgroundColor = UIColor.gray3
      layer.shadowOpacity = 0
      isUserInteractionEnabled = false
    }
  }
}
