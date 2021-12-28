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

final class NoteListViewController: BaseViewController<NoteListReactor> {
  
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
  
  private let searchBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .searchBarButton)
  }
  
  private let moreDetailButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .moreButton)
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
  
  private let addNoteButton = UIButton(type: .system).then {
    $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    $0.layer.shadowOpacity = 1
    $0.layer.shadowRadius = 20
    $0.layer.shadowOffset = CGSize(width: 0, height: 8)
    $0.layer.cornerRadius = 28
    $0.backgroundColor = .mainGreen
    $0.setTitle("+", for: .normal)
    $0.setTitleColor(.white, for: .normal)
  }
  
  // MARK: - Con(De)structor
  
  init(reactor: NoteListReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    UIApplication.shared.statusBarUIView?.backgroundColor = .clear
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
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    navigationItem.titleView = titleLabel
    navigationItem.leftBarButtonItem = backBarButton
    navigationItem.rightBarButtonItems = [
      moreDetailButton,
      searchBarButton
    ]
    navigationController?.navigationBar.backgroundColor = .white
    UIApplication.shared.statusBarUIView?.backgroundColor = .white
    view.addSubviews(
      tableView,
      addNoteButton
    )
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addNoteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(26)
      $0.width.height.equalTo(56)
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
