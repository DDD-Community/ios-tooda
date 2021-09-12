//
//  SettingsHeaderView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsHeaderView: UITableViewCell {
  
  private enum Font {
    static let title = TextStyle.captionBold(color: .gray2)
  }

  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier
    )
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal methods
  
  func configure(with title: String) {
    titleLabel.attributedText = title.styled(with: Font.title)
  }
}

// MARK: - configureUI
private extension SettingsHeaderView {

  func configureUI() {
    contentView.addSubview(titleLabel)
  }

  func configureConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
