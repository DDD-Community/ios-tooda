//
//  NoteDetailViewController.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/01/01.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class NoteDetailViewController: BaseViewController<NoteDetailReactor> {

  // MARK: Initializing

  init(reactor: NoteDetailReactor) {
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

  override func bind(reactor: NoteDetailReactor) {

    // Action
    self.rx.viewDidLoad
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Void> in
        guard let self = self else {
          return Observable<Void>.empty()
        }
        return self.configureBackBarButtonItemIfNeeded()
      }
      .map { NoteDetailReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
}