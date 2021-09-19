//
//  SettingsHeaderView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class SettingsHeaderView: BaseTableViewCell {
  
  // MARK: - Constants
  
  private enum Font {
    static let title = TextStyle.captionBold(color: .gray2)
  }

  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  // MARK: - Con(De)structor
  
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
      $0.top.equalToSuperview().inset(24)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}
