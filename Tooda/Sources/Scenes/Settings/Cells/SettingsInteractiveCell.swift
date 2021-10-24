//
//  SettingsInteractiveCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class SettingsInteractiveCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  struct Config {
    let title: String
    let description: String
    let isOn: Bool
  }
  
  enum Font {
    static let title = TextStyle.body2(color: .gray2)
    static let description = TextStyle.caption(color: .gray3)
  }
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  private let descriptionLabel = UILabel()
  
  private let cellSwitch = UISwitch()
  
  // MARK: - Internal methods
  
  func configure(with data: Config) {
    super.configure()
    titleLabel.attributedText = data.title.styled(with: Font.title)
    descriptionLabel.attributedText = data.description.styled(with: Font.description)
    cellSwitch.isOn = data.isOn
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    super.configureUI()
    selectionStyle = .none
    contentView.addSubviews(
      titleLabel,
      descriptionLabel,
      cellSwitch
    )
  }

  override func setupConstraints() {
    super.setupConstraints()
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.leading.equalToSuperview().inset(20)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.equalTo(titleLabel)
    }
    
    cellSwitch.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(48)
      $0.height.equalTo(24)
    }
  }
}
