//
//  SearchViewController.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/10/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class SearchViewController: BaseViewController<SearchReactor> {


  // MARK: Initializing

  init(reactor: SearchReactor) {
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

  override func bind(reactor: SearchReactor) {

    // Action
    self.rx.viewDidLoad
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Void> in
        guard let self = self else {
          return Observable<Void>.empty()
        }
        return self.configureBackBarButtonItemIfNeeded() }
      .map { SearchReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }

  override func configureUI() {

  }

  override func configureConstraints() {

  }
}
