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
  
  enum EditMode {
    case input
    case modify
  }
  
  private enum Font {
    static let title = TextStyle.titleBold(color: .gray1)
    static let descprtion = TextStyle.body(color: .gray3)
    static let searchField = TextStyle.body(color: .gray1)
    static let symbol = TextStyle.subTitleBold(color: .gray1)
    static let addButton = TextStyle.subTitleBold(color: .white)
  }
  
  private enum Color {
    static let borderLineGray: UIColor? = UIColor(type: .gray3)
  }
  
  private enum Metric {
    static let horizontalMargin: CGFloat = 24.0
    static let buttonWidth: CGFloat = 72.0
    static let addButtonHeight: CGFloat = 48
  }
  
  private let editMode: EditMode
  
  init(reactor: Reactor, editMode: EditMode) {
    defer {
      self.reactor = reactor
      
      if editMode == .modify {
        self.modalPresentationStyle = .overFullScreen
      }
    }
    
    self.editMode = editMode
    
    super.init()
  }
  
  // MARK: Properties
  
  // MARK: UI Properties
  
  private let closeBarButton = UIBarButtonItem(
    image: UIImage(type: .closeButton),
    style: .plain,
    target: nil,
    action: nil
  )
  
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
  }
  
  private let descriptionLabel = UILabel().then {
    $0.attributedText = "이 종목이 얼마나 변동했나요?".styled(with: Font.descprtion)
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  private let rateButtonStackView = RateSelectView(frame: .zero)
  
  private let textFieldBackgroundView = UIView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = Color.borderLineGray?.cgColor
    $0.layer.borderWidth = 1.0
  }
  
  private lazy var textField = UITextField().then {
    $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    $0.keyboardType = .numberPad
    $0.placeholder = "상승률/하락률"
  }
  
  private let percentLabel = UILabel().then {
    $0.attributedText = "%".styled(with: Font.symbol)
    $0.textAlignment = .right
    $0.numberOfLines = 1
    $0.sizeToFit()
  }
  
  private let buttonBackGroundView = UIView().then {
    $0.backgroundColor = UIColor(type: .white)
  }
  
  private let doneButton = UIButton(type: .system).then {
    $0.setBackgroundImage(UIColor.gray3.image(), for: .disabled)
    $0.setBackgroundImage(UIColor.mainGreen.image(), for: .normal)
    
    $0.layer.cornerRadius = CGFloat(Metric.addButtonHeight / 2)
    $0.layer.shadowColor = UIColor(hex: "#43475314").withAlphaComponent(0.08).cgColor
    $0.layer.shadowOffset = CGSize(width: 0, height: 12)
    $0.layer.shadowOpacity = 1
    $0.layer.shadowRadius = 12.0
    
    $0.layer.masksToBounds = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.initializeNavigation()
  }
  
  override func configureUI() {
    super.configureUI()
    
    [titleLabel, descriptionLabel, rateButtonStackView, textFieldBackgroundView, percentLabel, buttonBackGroundView].forEach {
      self.view.addSubview($0)
    }
    
    self.textFieldBackgroundView.addSubview(textField)
    
    self.buttonBackGroundView.addSubview(doneButton)
    
    let buttonTitle = self.editMode == .modify ? "수정".styled(with: Font.addButton) : "추가".styled(with: Font.addButton)
    
    self.doneButton.do {
      $0.setAttributedTitle(
        buttonTitle,
        for: .normal
      )
    }
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
    
    rateButtonStackView.snp.makeConstraints {
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(20)
      $0.left.equalToSuperview().offset(Metric.horizontalMargin)
      $0.height.equalTo(40)
    }
    
    textFieldBackgroundView.snp.makeConstraints {
      $0.top.equalTo(self.rateButtonStackView.snp.bottom).offset(20)
      $0.left.equalToSuperview().offset(Metric.horizontalMargin)
    }
    
    textField.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: 14, vertical: 11))
      $0.height.equalTo(23)
    }
    
    percentLabel.snp.makeConstraints {
      $0.centerY.equalTo(self.textFieldBackgroundView)
      $0.left.equalTo(self.textFieldBackgroundView.snp.right).offset(8)
      $0.right.equalToSuperview().offset(-34)
    }
    
    buttonBackGroundView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
    }
    
    doneButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.left.right.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-24)
      $0.height.equalTo(Metric.addButtonHeight)
    }
  }
  
  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)
    
    // Action
    self.rx.viewDidLoad
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Void> in
        return self?.configureBackBarButtonItemIfNeeded() ?? .empty() }
      .map { Reactor.Action.backbuttonDidTapped }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.doneButton.rx.tap
      .map { Reactor.Action.addButtonDidTapped }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.closeBarButton.rx.tap
      .map { Reactor.Action.closeButtonDidTapped }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // TODO: Reactor 바인딩 로직 추가 예정이에요.
    self.rateButtonStackView.rx.didSelectedChanged
      .asObservable()
      .distinctUntilChanged()
      .map { Reactor.Action.selectedStockDidChanged($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.textField.rx.text.orEmpty
      .map { Float($0) }
      .distinctUntilChanged()
      .map { Reactor.Action.textFieldDidChanged($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // State
    
    reactor.state
      .map { $0.name }
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] in
        self?.titleLabel.attributedText = $0.styled(with: Font.title)
      }).disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.buttonDidChanged }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        self?.addButtonDidChanged($0)
      }).disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.selectedRate == .even }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        self?.textFieldVisiblityDidChanged(by: $0)
      }).disposed(by: self.disposeBag)
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
  
  private func addButtonDidChanged(_ isEnabled: Bool) {
    self.doneButton.isEnabled = isEnabled
  }
  
  private func textFieldVisiblityDidChanged(by isEven: Bool) {
    isEven ? textFieldDidHidden() : textFieldDidShow()
  }
  
  private func textFieldDidHidden() {
    self.textFieldBackgroundView.isHidden = true
    self.percentLabel.isHidden = true
  }
  
  private func textFieldDidShow() {
    self.textFieldBackgroundView.isHidden = false
    self.percentLabel.isHidden = false
  }
}
