//
//  TextInputPopUpView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/07.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class TextInputPopUpView: BasePopUpView {
  
  // MARK: - Rx Stream
  
  lazy var textFieldStream = textField.rx.text
  
  // MARK: - UI Components
  
  private let textField = UITextField()
  
  // MARK: - Overridden: ParentClass

  override func setupUI() {
    super.setupUI()
    insertContentViewLayout(
      view: textField,
      margin: UIEdgeInsets(top: 20, left: 20, bottom: 26, right: 20)
    )
    
    textField.snp.makeConstraints {
      $0.height.equalTo(48)
    }
  }
}
