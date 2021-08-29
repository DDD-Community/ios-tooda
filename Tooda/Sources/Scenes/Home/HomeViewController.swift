//
//  HomeViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import Then
import SnapKit

final class HomeViewController: BaseViewController<HomeReactor> {

  // MARK: Constants

  private enum Typo {
    static let monthTitle = TextStyle.headlineBold(color: .gray1)
    static let noteCount = TextStyle.bodyBold(color: .gray2)
    static let noteCountSuffix = TextStyle.body(color: .gray2)
  }


  // MARK: UI

  private let searchBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .searchBarButton)
  }
  
  private let settingBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .settingBarButton)
  }

  private let monthTitleButton = UIButton().then {
    $0.semanticContentAttribute = .forceRightToLeft
    $0.setImage(
      UIImage(type: .iconDownGray),
      for: .normal
    )
    $0.setAttributedTitle("wrewr".styled(with: Typo.monthTitle), for: .normal)
  }

  private let noteCountLabel = UILabel().then {
    $0.numberOfLines = 1
    $0.attributedText = "3".styled(with: Typo.noteCount) + "werwerwe".styled(with: Typo.noteCountSuffix)
  }


  // MARK: Initializing

  init(reactor: HomeReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = nil
    self.view.backgroundColor = .white
  }
  
  override func configureUI() {
    self.navigationItem.rightBarButtonItems = [
      self.settingBarButton,
      self.searchBarButton
    ]

    self.view.do {
      $0.addSubview(self.monthTitleButton)
      $0.addSubview(self.noteCountLabel)
    }
  }

  override func configureConstraints() {
    self.monthTitleButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(57.0)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(CGSize(width: 136.0, height: 39.0))
    }

    self.noteCountLabel.snp.makeConstraints {
      $0.top.equalTo(self.monthTitleButton.snp.bottom).offset(5.0)
      $0.centerX.equalToSuperview()
    }
  }
}
