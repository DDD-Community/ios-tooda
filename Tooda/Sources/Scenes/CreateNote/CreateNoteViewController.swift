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
      let cell = tableView.dequeue(NoteContentCell.self, indexPath: indexPath)
      cell.configure(reactor: reactor)
      return cell
    case .addStock(let reactor):
      let cell = tableView.dequeue(EmptyNoteStockCell.self, indexPath: indexPath)
      cell.configure(reactor: reactor)
      return cell
    case .image(let cellReactor):
      let cell = tableView.dequeue(NoteImageCell.self, indexPath: indexPath)
      cell.configure(reactor: cellReactor)
      
      cell.rx.didSelectedItemCell
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .map { Reactor.Action.didSelectedImageItem($0) }
        .subscribe(onNext: { [weak self] in
          self?.reactor?.action.onNext($0)
        })
        .disposed(by: cell.disposeBag)
      
      cell.selectionStyle = .none
      
      return cell
    default:
      return UITableViewCell()
    }
  })


  // MARK: UI-Properties

  let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.alwaysBounceHorizontal = false

    $0.register(NoteContentCell.self)
    $0.register(EmptyNoteStockCell.self)
    $0.register(NoteImageCell.self)
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

    // State
    reactor.state
      .map { $0.sections }
      .debug()
      .bind(to: self.tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.requestPermissionMessage }
      .filter { $0 != nil }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] in
        self?.showAlertAndOpenAppSetting(message: $0)
      })
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.showAlertMessage }
      .filter { $0 != nil }
      .observeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] in
        self?.showAlert(message: $0)
      })
      .disposed(by: self.disposeBag)
  }
}

// MARK: ViewController Configuration

extension CreateNoteViewController {
  func configureNavigation() {
    self.navigationItem.title = Date().description
  }
}

// MARK: ETC

extension CreateNoteViewController {
  func showAlert(message: String?) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
    
    alertController.addAction(ok)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func showAlertAndOpenAppSetting(message: String?) {
    
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction.init(title: "확인", style: .default, handler: { [weak self] _ in
      self?.openAppSettingMenu()
    })
    
    alertController.addAction(ok)
    
    self.present(alertController, animated: true, completion: nil)
  }
}
