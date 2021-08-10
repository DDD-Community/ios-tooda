//
//  LoginViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/06/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxSwift
import RxCocoa
import SnapKit
import Then

class LoginViewController: BaseViewController<LoginReactor> {
  
  // MARK: Constants

  private enum Constants {
    static let title = TextStyle.title(color: .white)
    static let loginButtonHeight: CGFloat = 56
  }
  
  // MARK: - UI Components
  
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(type: .login)
  }
  
  private let loginButton = UIButton().then {
    $0.setAttributedTitle(
      "시작하기".styled(with: Constants.title),
      for: .normal
    )
    $0.backgroundColor = ToodaAsset.Colors.mainGreen.color
    $0.layer.cornerRadius = CGFloat(Constants.loginButtonHeight / 2)
    $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.25).cgColor
    $0.layer.shadowOffset = CGSize(width: 4, height: 4)
    $0.layer.shadowOpacity = 1
  }
  
  // MARK: - Con(De)structor
  
  init(reactor: LoginReactor) {
    super.init()
    self.reactor = reactor
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindUI()
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
    print(#function)
    // Action
    loginButton.rx.tap
      .map { _ in LoginReactor.Action.login }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State
    reactor.state.map { $0.isAuthorized }
      .bind { isAuthorized in
      // TODO: if sth changed when authorized
    }
    .disposed(by: disposeBag)
  }
  
  // MARK: - SetupUI
  
  private func bindUI() {
    
    Observable<Void>.merge(
      loginButton.rx.controlEvent(.touchUpOutside).asObservable(),
      loginButton.rx.controlEvent(.touchUpInside).asObservable()
    )
    .asDriver(onErrorJustReturn: ())
    .drive { [weak self] _ in
      self?.loginButton.layer.shadowOpacity = 1
    }
    .disposed(by: disposeBag)
    
    loginButton.rx.controlEvent(.touchDown)
      .asDriver()
      .drive { [weak self] _ in
        self?.loginButton.layer.shadowOpacity = 0
      }
      .disposed(by: disposeBag)
  }
  
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
      $0.height.equalTo(Constants.loginButtonHeight)
    }
  }
}
