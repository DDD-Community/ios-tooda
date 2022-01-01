//
//  TextInputPopUpView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/07.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class TextInputPopUpView: BasePopUpView {
  
  // MARK: - Constants
  
  private enum Font {
    static let placeholder = TextStyle.body(color: .gray2)
  }
  
  // MARK: - RxStream
  
  lazy var textInputStream = textField.rx.text.asObservable()
  
  // MARK: - UI Components
  
  private let textField = UITextField().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray5.cgColor
    $0.layer.cornerRadius = 8
    $0.addLeftInputCursorPadding(padding: 13.7)
    $0.attributedPlaceholder = "URL을 입력하세요 (최대 2개)".styled(with: Font.placeholder)
    $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    $0.textColor = UIColor.gray2
  }
  
  // MARK: - Overridden: ParentClass
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupUI() {
    super.setupUI()
    insertContentViewLayout(
      view: textField,
      margin: UIEdgeInsets(top: 20, left: 20, bottom: 26, right: 20)
    )
    
    textField.snp.makeConstraints {
      $0.height.equalTo(48)
    }
    
    setBottomButtonOnOff(isOn: false)
  }
  
  private func bindUI() {
    textField.rx.text.asDriver()
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        if let text = $0, !text.isEmpty {
          self.setBottomButtonOnOff(isOn: true)
        } else {
          self.setBottomButtonOnOff(isOn: false)
        }
      })
      .disposed(by: self.disposeBag)
  }
}
