//
//  AddStockViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/10/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources
import RxSwift
import RxCocoa
import SnapKit
import Then
import UIKit

final class AddStockViewController: BaseViewController<AddStockReactor> {
  
  typealias Reactor = AddStockReactor
  typealias Section = RxTableViewSectionedReloadDataSource<AddStockSection>
  
  // MARK: Constants
  
  private enum Metric {
    static let verticalMargin: CGFloat = 16
    static let horizontalMargin: CGFloat = 14
  }
  
    // MARK: Properties
  let dataSource: Section = Section(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
    switch item {
      case .item(let reactor):
        let cell = tableView.dequeue(StockItemCell.self, indexPath: indexPath)
        cell.configure(reactor: reactor)
        return cell
    }
  })
  
  // MARK: UI Components
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.register(StockItemCell.self)
  }
  
  private let closeBarButton = UIBarButtonItem(
    image: UIImage(type: .closeButton)?.withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: nil,
    action: nil
  )
  
  // MARK: Initialzier
  
  init(reactor: Reactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    print("\(#file) deinitialized")
  }
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.initializeNavigation()
  }
  
  // MARK: Bind
  
  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)
    
    // Action
    
    // TODO: Reactor Action으로 변경
    self.closeBarButton.rx.tap
      .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: self.disposeBag)
    
    // State
  }
  
  // MARK: SetupUI
  
  override func configureUI() {
    super.configureUI()
    
    self.view.backgroundColor = .white
    
    self.view.addSubview(tableView)
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(Metric.verticalMargin)
      $0.left.equalToSuperview().offset(Metric.horizontalMargin)
      $0.right.equalToSuperview().offset(-Metric.horizontalMargin)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
  }
}

// MARK: - Extensions

extension AddStockViewController {
  private func initializeNavigation() {
    self.navigationItem.title = "종목 기록하기"
    self.navigationItem.rightBarButtonItem = closeBarButton
  }
}
