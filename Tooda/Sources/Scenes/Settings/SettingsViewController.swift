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
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

// MARK: - configureUI
private extension SettingsInteractiveCell {

  override func configureUI() {
    
  }

  override func configureConstraints() {
    
  }
}

