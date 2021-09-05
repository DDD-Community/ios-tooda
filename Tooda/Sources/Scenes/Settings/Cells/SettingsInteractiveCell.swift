//
//  SettingsInteractiveCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsInteractiveCell: UITableViewCell {
  
  enum Font {
    
  }
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  private let descriptionLabel = UILabel()
  
  private let cellSwitch = UISwitch()
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - configureUI
private extension SettingsInteractiveCell {

  func configureUI() {
    contentView.addSubviews(
      titleLabel,
      descriptionLabel,
      cellSwitch
    )
  }

  func configureConstraints() {
    
  }
}
