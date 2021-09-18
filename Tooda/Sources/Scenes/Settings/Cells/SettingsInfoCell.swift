//
//  SettingsInfoCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsInfoCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  private enum Font {
    static let title = TextStyle.body2(color: .gray2)
  }
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  private let trailingImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(type: .iconArrowRightGray)
  }
  
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
    contentView.addSubviews(
      titleLabel,
      trailingImageView
    )
  }
  
  override func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
    
    trailingImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
