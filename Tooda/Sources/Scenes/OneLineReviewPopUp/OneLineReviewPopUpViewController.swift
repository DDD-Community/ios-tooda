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

class PopUpViewController: BaseViewController<PopUpReactor> {
  
  // MARK: - Constants
  
  enum PopUpType {
    case list
    case textInput(PublishRelay<String>)
  }
  
  // MARK: - UI Components
  
  private let dimmedView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.4)
  }
  
  private let optionsPopUpView = OptionsPopUpView().then {
    $0.isHidden = true
    $0.alpha = 0
  }
  
  private let textInputPopUpView = TextInputPopUpView().then {
    $0.isHidden = true
    $0.alpha = 0
  }
  
  private let type: PopUpType
  
  private let displayPopUpAnimator = UIViewPropertyAnimator(
    duration: 0.5,
    curve: .easeOut
  )
  
  // MARK: - Con(De)structor
  
  init(reactor: PopUpReactor, type: PopUpType) {
    self.type = type
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func showPopUpView() {
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

// MARK: - SetupUI
extension PopUpViewController {
  private func setupUI() {
    view.do {
      $0.backgroundColor = .clear
      $0.addSubview(dimmedView)
    }
    
    dimmedView.addSubviews(
      optionsPopUpView,
      textInputPopUpView
    )
    
    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    optionsPopUpView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    textInputPopUpView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
