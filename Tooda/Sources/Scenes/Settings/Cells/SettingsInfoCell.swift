//
//  SettingsInfoCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsInfoCell: UITableViewCell {
  
  private let titleLabel = UILabel()
  
  private let trailingImageView = UIImageView()

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
private extension SettingsInfoCell {

  func configureUI() {
    contentView.addSubviews(
      titleLabel,
      trailingImageView
    )
  }

  func configureConstraints() {
    
  }
}
