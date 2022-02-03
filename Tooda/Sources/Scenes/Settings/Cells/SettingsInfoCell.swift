//
//  SettingsInfoCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class SettingsInfoCell: BaseTableViewCell {
  
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
  
  // MARK: - Internal methods
  
  func configure(with title: String, shouldArrowHidden: Bool) {
    super.configure()
    titleLabel.attributedText = title.styled(with: Font.title)
    
    trailingImageView.isHidden = shouldArrowHidden
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    super.configureUI()
    selectionStyle = .none
    contentView.addSubviews(
      titleLabel,
      trailingImageView
    )
  }
  
  override func setupConstraints() {
    super.setupConstraints()
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
