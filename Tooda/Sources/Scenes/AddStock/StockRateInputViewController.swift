//
//  StockRateInputViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then

class ReactorViewController: BaseViewController<StockRateInputReactor> {
  typealias Reactor = StockRateInputReactor
  
  // MARK: Enum
  
  private enum Font {
    static let title = TextStyle.titleBold(color: .gray1)
    static let descprtion = TextStyle.body(color: .gray3)
    static let searchField = TextStyle.body(color: .gray1)
  }
  
  private enum Color {
    static let borderLineGray: UIColor? = UIColor(type: .gray3)
  }
  
  init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  // MARK: Properties
  
  // MARK: UI Properties
  
  private let closeBarButton = UIBarButtonItem(
    image: UIImage(type: .closeButton)?.withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: nil,
    action: nil
  )
  
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.sizeToFit()
  }
  
  private let descriptionLabel = UILabel().then {
    $0.attributedText = "이 종목이 얼마나 변동했나요?".styled(with: Font.descprtion)
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  private let textFieldBackgroundView = UIView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = Color.borderLineGray?.cgColor
    $0.layer.borderWidth = 1.0
  }
  
  private lazy var textField = UITextField().then {
    $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
  }
  
  private let percentLabel = UILabel().then {
    $0.attributedText = "%".styled(with: TextStyle.subTitleBold(color: .gray1))
    $0.textAlignment = .right
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }
  
  override func configureUI() {
    super.configureUI()
  }
  
  override func configureConstraints() {
    super.configureConstraints()
  }
  
  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)
  }
  
  @objc
  func textFieldDidChange(textField: UITextField) {
    textField.attributedText = textField.text?.styled(with: Font.searchField)
  }
}

// MARK: - Extensions

extension ReactorViewController {
  private func initializeNavigation() {
    self.navigationItem.title = "종목 기록하기"
    self.navigationItem.rightBarButtonItem = closeBarButton
  }
}
