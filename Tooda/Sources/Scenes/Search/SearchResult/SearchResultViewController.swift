//
//  SearchResultViewController.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/12/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class SearchResultViewController: BaseViewController<SearchResultReactor> {

  // MARK: Initializing

  init(reactor: SearchResultReactor) {
    super.init()
    self.reactor = reactor
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  override func configureUI() {

  }

  override func configureConstraints() {

  }


  // MARK: Bind

  override func bind(reactor: SearchResultReactor) {

  }
}
