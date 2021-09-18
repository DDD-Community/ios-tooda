//
//  SettingsSectionFooterView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class SettingsSectionFooterView: BaseTableViewCell {
  
  // MARK: - Constants
  
  enum Font {
    static let title = TextStyle.body2(color: .gray2)
  }
  
  // MARK: - UI Components
  
  private let titleLabel = UILabel()
  
  private let grayBottomView = UIView().then {
    $0.backgroundColor = .gray5
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
  
  func configure(title: String?) {
    if let title = title {
      titleLabel.isHidden = false
      titleLabel.attributedText = title.styled(with: Font.title)
    } else {
      titleLabel.isHidden = true
    }
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    contentView.addSubviews(
      titleLabel,
      grayBottomView
    )
  }
  
  override func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(grayBottomView.snp.top).offset(-20)
    }
    
    grayBottomView.snp.makeConstraints {
      $0.bottom.leading.trailing.equalToSuperview()
      $0.height.equalTo(8)
    }
  }
}
