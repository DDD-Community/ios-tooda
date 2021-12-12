//
//  OptionsPopUpView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class OptionsPopUpView: BasePopUpView {
  
  // MARK: - UI Components
  
  private let tableView = SelfSizingTableView()
  
  // MARK: - Overridden: ParentClass

  override func setupUI() {
    super.setupUI()
    insertContentViewLayout(
      view: tableView,
      margin: UIEdgeInsets(top: 18, left: 0, bottom: 26, right: 0)
    )
  }
}
