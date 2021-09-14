//
//  SettingsInteractiveCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsInteractiveCell: BaseTableViewCell {
  
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
  
  // MARK: - configureUI
  
  override func configureUI() {
    contentView.addSubviews(
      titleLabel,
      descriptionLabel,
      cellSwitch
    )
  }

  override func configureConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(8)
      $0.leading.equalToSuperview().inset(20)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.equalTo(titleLabel)
    }
    
    cellSwitch.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
