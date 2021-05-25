//
//  CreateNoteViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import RxViewController

import RxDataSources
import ReactorKit
import SnapKit

class CreateNoteViewController: BaseViewController<CreateNoteViewReactor> {
  typealias Reactor = CreateNoteViewReactor

  typealias Section = RxTableViewSectionedReloadDataSource<NoteSection>


  // MARK: Properties
  lazy var dataSource: Section = Section(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
    switch item {
    case .content(let reactor):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteContentCell.reuseIdentifierName, for: indexPath) as? NoteContentCell else { return UITableViewCell() }
      cell.configure(reactor: reactor)
      return cell
    case .addStock(let reactor):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyNoteStockCell.reuseIdentifierName, for: indexPath) as? EmptyNoteStockCell else { return UITableViewCell() }
      cell.configure(reactor: reactor)
      return cell
    case .image(let reactor):
      guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteImageCell.reuseIdentifierName, for: indexPath) as? NoteImageCell else { return UITableViewCell() }
      cell.configure(reactor: reactor)
      return cell
    default:
      return UITableViewCell()
    }
  })


  // MARK: UI-Properties
  
  let addNoteBackgroundView = UIButton().then {
    $0.setTitle("등록", for: .normal)
    $0.setTitleColor(UIColor(type: .white), for: .normal)
    $0.backgroundColor = UIColor(type: .gray3)
    $0.layer.cornerRadius = 8.0
    $0.layer.masksToBounds = true
    $0.frame = CGRect(x: 0, y: 0, width: 53, height: 28)
  }
  
  private lazy var addNoteBarButton = UIBarButtonItem(customView: self.addNoteBackgroundView)

  let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.alwaysBounceHorizontal = false

    $0.register(NoteContentCell.self, forCellReuseIdentifier: NoteContentCell.reuseIdentifierName)
    $0.register(EmptyNoteStockCell.self, forCellReuseIdentifier: EmptyNoteStockCell.reuseIdentifierName)
    $0.register(NoteImageCell.self, forCellReuseIdentifier: NoteImageCell.reuseIdentifierName)
  }

  // MARK: Initialize

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func configureUI() {
    super.configureUI()

    self.view.backgroundColor = .white

    [tableView].forEach {
      self.view.addSubview($0)
    }
  }

  override func configureConstraints() {
    super.configureConstraints()

    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      $0.left.equalToSuperview().offset(14)
      $0.right.equalToSuperview().offset(-14)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }

  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)

    // Action
    Observable.just(())
      .map { _ in Reactor.Action.initializeForm }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    tableView.rx.itemSelected
      .map { Reactor.Action.didSelectedItem($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    addNoteBackgroundView.rx.tap
      .throttle(.milliseconds(5), scheduler: MainScheduler.instance)
      .map { _ in Reactor.Action.regist }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    reactor.state
      .map { $0.sections }
      .debug()
      .bind(to: self.tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
  }
}

// MARK: ViewController Configuration

extension CreateNoteViewController {
  func configureNavigation() {
    self.navigationItem.title = Date().description
    
    self.navigationItem.rightBarButtonItem = self.addNoteBarButton
  }
}
