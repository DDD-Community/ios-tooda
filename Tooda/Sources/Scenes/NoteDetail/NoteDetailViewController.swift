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
  
  // MARK: UI Properties
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.alwaysBounceHorizontal = false
    
    $0.allowsSelection = false
  }

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
    super.configureUI()
    self.view.addSubviews(tableView)
  }

  override func configureConstraints() {
    super.configureConstraints()
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
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
