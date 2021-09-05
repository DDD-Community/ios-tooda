//
//  SettingsHeaderView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsHeaderView: UITableViewCell {

  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - configureUI
private extension SettingsHeaderView {

  func configureUI() {
    
  }

  func configureConstraints() {
    
  }
}
