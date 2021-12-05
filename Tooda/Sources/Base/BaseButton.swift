//
//  BaseButton.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
  
  enum Font {
    static let title = TextStyle.subTitleBold(color: .white)
  }
  
  var width: CGFloat?
  var height: CGFloat

  override var buttonType: UIButton.ButtonType {
    return .system
  }
  
  init(width: CGFloat?, height: CGFloat) {
    self.width = width
    self.height = height
    super.init(frame: .zero)
    baseConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func baseConfigure() {
    self.do {
      $0.backgroundColor = ToodaAsset.Colors.mainGreen.color
      $0.layer.cornerRadius = CGFloat(height / 2)
      $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
      $0.layer.shadowOffset = CGSize(width: 4, height: 4)
      $0.layer.shadowOpacity = 1
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
  }
  
  func setButtonTitle(with title: String) {
    setAttributedTitle(
      title.styled(with: Font.title),
      for: .normal
    )
  }
}
