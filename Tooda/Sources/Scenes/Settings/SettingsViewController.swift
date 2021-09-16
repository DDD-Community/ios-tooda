//
//  SettingsViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController<HomeReactor> {
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = .white
    $0.register(SettingsHeaderView.self)
    $0.register(SettingsInfoCell.self)
    $0.register(SettingsInteractiveCell.self)
    $0.register(SettingsSectionFooterView.self)
    $0.register(SettingsTableFooterView.self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bind(reactor: HomeReactor) {
    self.tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    view.addSubview(tableView)
  }

  override func configureConstraints() {
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
