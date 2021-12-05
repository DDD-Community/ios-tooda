//
//  OneLineReviewOptionCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class OneLineReviewOptionCell: BaseTableViewCell {
  
  // MARK: - UI Components
  
  private let cardView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray1.cgColor
  }
  
  private let emojiImageView = UIImageView()
  
  private let titleLabel = UILabel()
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier
    )
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setSelected(isSelected: Bool) {
    cardView.backgroundColor = .black
  }
}

// MARK: - SetupUI
extension OneLineReviewOptionCell {
  private func setupUI() {
    contentView.do {
      $0.backgroundColor = .white
      $0.addSubview(cardView)
    }
    
    cardView.addSubviews(
      emojiImageView,
      titleLabel
    )
    
    cardView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(
        UIEdgeInsets(horizontal: 20, vertical: 4)
      )
    }
    
    emojiImageView.snp.makeConstraints {
      $0.width.height.equalTo(30)
      $0.leading.equalToSuperview().inset(14)
      $0.top.bottom.equalToSuperview().inset(10)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(emojiImageView.snp.trailing).offset(21)
      $0.centerY.equalTo(emojiImageView)
      $0.trailing.equalToSuperview().inset(20)
    }
  }
}
