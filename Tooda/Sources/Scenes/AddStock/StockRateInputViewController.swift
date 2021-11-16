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

class StockRateInputViewController: BaseViewController<StockRateInputReactor> {
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
  
  private enum Metric {
    static let horizontalMargin: CGFloat = 24.0
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
    // TODO: Mock 데이터 제거할 예정이에요.
    $0.attributedText = "삼성전자".styled(with: Font.title)
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
    $0.placeholder = "상승률/하락률"
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
    
    [titleLabel, descriptionLabel, textFieldBackgroundView, percentLabel].forEach {
      self.view.addSubview($0)
    }
    
    self.textFieldBackgroundView.addSubview(textField)
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(32)
      $0.left.right.equalToSuperview().inset(Metric.horizontalMargin)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(8)
      $0.left.right.equalToSuperview().inset(Metric.horizontalMargin)
    }
    
    textFieldBackgroundView.snp.makeConstraints {
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(23)
      $0.left.equalToSuperview().offset(Metric.horizontalMargin)
    }
    
    textField.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 11, left: 14, bottom: 11, right: 14))
      $0.height.equalTo(23)
    }
    
    percentLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.textFieldBackgroundView.snp.centerY)
      $0.left.equalTo(self.textFieldBackgroundView.snp.right).offset(8)
      $0.right.equalToSuperview().offset(-34)
    }
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

extension StockRateInputViewController {
  private func initializeNavigation() {
    self.navigationItem.title = "종목 기록하기"
    self.navigationItem.rightBarButtonItem = closeBarButton
  }
}