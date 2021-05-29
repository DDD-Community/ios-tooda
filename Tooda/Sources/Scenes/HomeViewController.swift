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

final class HomeViewController: BaseViewController<HomeReactor> {

  // MARK: Constants

  private enum Typo {
    static let title = TextStyle.body(color: .white)
  }

  
  private let searchBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .searchBarButton)
  }
  
  private let settingBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .settingBarButton)
  }
  
  init(reactor: HomeReactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = nil
    self.view.backgroundColor = .white
  }
  
  override func bind(reactor: HomeReactor) {
  }
  
  override func configureUI() {
    self.navigationItem.rightBarButtonItems = [
      self.settingBarButton,
      self.searchBarButton
    ]

    UILabel().attributedText = "test".styled(with: Typo.title)
  }
  
}
