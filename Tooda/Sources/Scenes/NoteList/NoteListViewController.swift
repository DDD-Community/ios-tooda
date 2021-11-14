//
//  NoteListViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/28.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources

class NoteListViewController: BaseViewController<NoteListReactor> {
  
  // MARK: - Constants
  
  typealias Section = RxTableViewSectionedReloadDataSource<NoteListModel>
  
  private enum Font {
    static let title = TextStyle.subTitle(color: .gray1)
  }
  
  // MARK: Properties
  
  lazy var dataSource: Section = Section(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
    let cell = tableView.dequeue(NoteListCell.self, indexPath: indexPath)
    cell.configure(with: item)
    return cell
  })
  
  // MARK: - UI Components
  
  private lazy var titleLabel = UILabel().then {
    $0.attributedText = "2021년 1월".styled(with: Font.title)
  }
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = .gray5
    $0.register(UITableViewCell.self)
    $0.register(NoteListCell.self)
    $0.separatorStyle = .none
    $0.delegate = self
  }
  
  private let backBarButton = UIBarButtonItem(
     image: UIImage(type: .backBarButton)?.withRenderingMode(.alwaysOriginal),
     style: .plain,
     target: nil,
     action: nil
   )
  
  // MARK: - Con(De)structor
  
  init(reactor: NoteListReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overridden: ParentClass
  
  override func bind(reactor: NoteListReactor) {
    rx.viewWillAppear.take(1)
      .map { _ in NoteListReactor.Action.initialLoad }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.noteListModel }
      .bind(to: tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    navigationItem.titleView = titleLabel
    navigationItem.leftBarButtonItem = backBarButton
    view.addSubview(tableView)
  }

  override func configureConstraints() {
    super.configureConstraints()
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return UITableView.automaticDimension
  }
}
