//
//  SettingsTableFooterView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/16.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsTableFooterView: BaseTableViewCell {
  
  // MARK: - Constants
  
  enum Font {
    static let title = TextStyle.caption(color: .gray3)
  }

  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  // MARK: - Internal methods
  
  func configure(with title: String) {
    titleLabel.attributedText = title.styled(with: Font.title)
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    contentView.addSubview(titleLabel)
  }

  override func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}
