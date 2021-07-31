//
//  LoginViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/06/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import SnapKit
import Then

class LoginViewController: BaseViewController<LoginReactor> {
  
  // MARK: Constants

  private enum Typo {
    static let title = TextStyle.title(color: .white)
  }
  
  // MARK: - UI Components
  
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(type: .login)
  }
  
  private let loginButton = UIButton().then {
    $0.setAttributedTitle(
      "시작하기".styled(with: Typo.title),
      for: .normal
    )
    $0.backgroundColor = ToodaAsset.Colors.mainGreen.color
    $0.layer.cornerRadius = 28
  }
  
  // MARK: - Con(De)structor
  
  init(reactor: LoginReactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#file) deinitialized")
  }
  
  // MARK: - Bind
  
  override func bind(reactor: LoginReactor) {
    super.bind(reactor: reactor)
    
    // Action
    loginButton.rx.tap
      .map { _ in LoginReactor.Action.login }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    
    // State
    reactor.state.map { $0.isAuthorized }
      .bind { isAuthorized in
      // TODO:
    }
    .disposed(by: disposeBag)
  }
  
  // MARK: - SetupUI
  
  override func configureUI() {
    view.backgroundColor = .white
  }
  
  override func configureConstraints() {
    view.addSubviews(
      mainImageView,
      loginButton
    )
    
    mainImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(79)
      $0.top.equalToSuperview().offset(114)
      $0.width.equalTo(243)
      $0.height.equalTo(515)
    }
    
    loginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-34)
      $0.height.equalTo(56)
    }
  }
}