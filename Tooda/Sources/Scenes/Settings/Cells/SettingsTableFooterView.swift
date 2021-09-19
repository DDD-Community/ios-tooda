//
//  SettingsTableFooterView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/16.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class SettingsTableFooterView: BaseTableViewCell {
  
  // MARK: - Constants
  
  enum Font {
    static let title = TextStyle.caption(color: .gray3)
  }
  
  enum Text {
    static let copyright = "Copyright © tooda, All Rights Reserved."
  }

  // MARK: - UI Components
  
  private let titleLabel = UILabel().then {
    $0.attributedText = Text.copyright.styled(with: Font.title)
    $0.textAlignment = .center
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    backgroundColor = .gray5
    contentView.addSubview(titleLabel)
  }

  override func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
}
