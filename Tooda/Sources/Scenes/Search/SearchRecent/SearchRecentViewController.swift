//
//  SearchRecentViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class SearchRecentViewController: BaseViewController<SearchRecentReactor> {

  // MARK: Initialzing

  init(reactor: SearchRecentReactor) {
    super.init()
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }


  // MARK: Bind

  override func bind(reactor: SearchRecentReactor) {

  }

  override func configureUI() {

  }

  override func configureConstraints() {

  }
}
