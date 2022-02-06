//
//  PopUpViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

final class PopUpViewController: BaseViewController<PopUpReactor> {
  
  // MARK: - Constants
  
  private enum Constants {
    static let minimumKeyboardMargin: CGFloat = 30.0
  }
  
  private enum Font {
    static let popupTitle = TextStyle.subTitleBold(color: .gray1)
    static let bottomButtonTitle = TextStyle.subTitleBold(color: .white)
  }
  
  // MARK: - UI Components
  
  private let dimmedView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.4)
  }
  
  private let optionsPopUpView = OptionsPopUpView().then {
    $0.setTitle(with: "오늘의 한줄평", style: Font.popupTitle)
    $0.setBottomButtonTitle(with: "작성 완료", style: Font.bottomButtonTitle)
    $0.isHidden = true
    $0.alpha = 0
  }
  
  private let textInputPopUpView = TextInputPopUpView().then {
    $0.setTitle(with: "URL 입력", style: Font.popupTitle)
    $0.setBottomButtonTitle(with: "추가", style: Font.bottomButtonTitle)
    $0.isHidden = true
    $0.alpha = 0
  }
  
  private let displayPopUpAnimator = UIViewPropertyAnimator(
    duration: 0.4,
    dampingRatio: 0.5
  )
  
  // MARK: - Con(De)structor
  
  init(reactor: PopUpReactor) {
    super.init()
    self.reactor = reactor
    bindUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overridden: ParentClass
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    showPopUpView()
  }
  
  override func configureUI() {
    super.configureUI()
    
    view.do {
      $0.backgroundColor = .clear
      $0.addSubview(dimmedView)
    }
    
    dimmedView.addSubviews(
      optionsPopUpView,
      textInputPopUpView
    )
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    optionsPopUpView.snp.makeConstraints {
      $0.width.equalTo(315)
      $0.center.equalToSuperview()
    }
    
    textInputPopUpView.snp.makeConstraints {
      $0.width.equalTo(315)
      $0.centerY.equalToSuperview().offset(0)
      $0.centerX.equalToSuperview()
    }
  }
  
  override func bind(reactor: PopUpReactor) {
    switch reactor.dependency.type {
    case .list:
      let sectionModelStream = reactor.state
        // sticker set 될 때 마다 binding 되는 것 방지
        .filter { $0.selectedSticker == nil }
        .map { $0.emojiOptionsSectionModels }
      optionsPopUpView.bindDataSource(sectionModel: sectionModelStream)
      
      optionsPopUpView.didSelectOptionStream
        .map { $0.row }
        .map { PopUpReactor.Action.didSelectOption($0) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    default:
      break
    }
    
    Observable<Void>.merge(
      [optionsPopUpView.didTapDismissButton,
       textInputPopUpView.didTapDismissButton])
      .map { PopUpReactor.Action.dismiss }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    optionsPopUpView.didTapBottomButton
      .map { PopUpReactor.Action.didTapBottonButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    textInputPopUpView.didTapBottomButton
      .withLatestFrom(textInputPopUpView.textInputStream)
      .compactMap { $0 }
      .map { PopUpReactor.Action.didAddTextInput($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state.map { $0.selectedSticker }
      .asDriver(onErrorJustReturn: nil)
      .drive { [weak self] sticker in
        guard let self = self else { return }
        self.optionsPopUpView.setBottomButtonOnOff(isOn: sticker != nil)
      }
      .disposed(by: disposeBag)
  }
  
  private func bindUI() {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillChangeFrameNotification)
      .map { notification -> CGRect? in
        let rectValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return rectValue?.cgRectValue
      }
      .asDriver(onErrorJustReturn: nil)
      .compactMap { $0 }
      .drive(onNext: { [weak self] keyboardFrame in
        guard let self = self else { return }
        let inputPopUpFrame = self.textInputPopUpView.frame
        let interFrame = inputPopUpFrame.intersection(keyboardFrame)
        self.updatePopUpLayout(with: interFrame, isShowingUp: true)
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .map { _ -> CGRect in return CGRect.zero }
      .asDriver(onErrorJustReturn: .zero)
      .drive(onNext: { [weak self] keyboardFrame in
        guard let self = self else { return }
        self.updatePopUpLayout(with: keyboardFrame, isShowingUp: false)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private methods
  
  private func updatePopUpLayout(
    with intersection: CGRect,
    isShowingUp: Bool
  ) {
    var margin = isShowingUp ? Constants.minimumKeyboardMargin : 0
    margin += intersection.height
    textInputPopUpView.snp.updateConstraints {
      $0.centerY.equalToSuperview().offset(-margin)
    }
  }
  
  private func showPopUpView() {
    guard let type = reactor?.dependency.type else { return }
    switch type {
    case .list:
      optionsPopUpView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      displayPopUpAnimator.do {
        $0.addAnimations {
          self.optionsPopUpView.isHidden = false
          self.optionsPopUpView.transform = .identity
          self.optionsPopUpView.alpha = 1
        }
      }
    case .textInput:
      textInputPopUpView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
      displayPopUpAnimator.do {
        $0.addAnimations {
          self.textInputPopUpView.isHidden = false
          self.textInputPopUpView.transform = .identity
          self.textInputPopUpView.alpha = 1
        }
      }
    }
    displayPopUpAnimator.startAnimation()
  }
}
