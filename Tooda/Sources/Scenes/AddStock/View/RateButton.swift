//
//  RateButton.swift
//  Tooda
//
//  Created by Lyine on 2021/11/26.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class RateButton: UIButton {
  
  private enum Font {
    static let disabledStyle = TextStyle.body(color: .gray2)
  }
  
  private enum Const {
    static let disabledColor = UIColor.gray2
  }
  
  let stockState: StockChangeState
  
  override var isSelected: Bool {
    willSet(newValue) {
      self.buttonLayerDidChanged(by: newValue)
    }
  }
  
  init(stockState: StockChangeState) {
    defer {
      self.configure()
    }
    self.stockState = stockState
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(){
    self.backgroundColor = .white
    self.layer.cornerRadius = 10.0
    self.layer.borderWidth = 1.0
    self.layer.borderColor = Const.disabledColor.cgColor
    
    self.configureStyle()
  }
  
  private func configureStyle() {
    
    let title = self.stockState.titleText
    
    self.setAttributedTitle(title.styled(with: Font.disabledStyle), for: .normal)
    
    self.setAttributedTitle(title.styled(with: TextStyle.bodyBold(color: self.stockState.titleColor)), for: .selected)
  }
  
  private func buttonLayerDidChanged(by isSelected: Bool) {
    self.layer.borderColor = isSelected ? self.stockState.titleColor.cgColor : Const.disabledColor.cgColor
  }
}
