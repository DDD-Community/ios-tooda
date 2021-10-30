//
//  NoteListCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/10/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import SnapKit

class NoteListCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  enum Font {
    static let title = TextStyle.subTitleBold(color: .gray1)
    static let recordDate = TextStyle.captionBold(color: .gray3)
    static let description = TextStyle.bodyBold(color: .gray1)
  }
  
  // MARK: - UI Components
  
  private let cardView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let emojiImageView = UIImageView()
  
  private let titleLabel = UILabel()
  
  private let recordDateLabel = UILabel()
  
  private let descriptionLabel = UILabel()
  
  private let mainImageView = UIImageView()


  override func configureUI() {
    super.configureUI()
    contentView.do {
      $0.backgroundColor = .gray5
      $0.addSubview(cardView)
    }
    
    cardView.addSubviews(
      emojiImageView,
      titleLabel,
      recordDateLabel,
      descriptionLabel,
      mainImageView
    )
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    cardView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(6)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(6)
    }
    
    emojiImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(22)
      $0.top.equalToSuperview().inset(27)
      $0.width.height.equalTo(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.centerY.equalTo(emojiImageView)
      $0.leading.equalTo(emojiImageView.snp.trailing).offset(9)
    }
    
    recordDateLabel.snp.makeConstraints {
      $0.leading.equalTo(emojiImageView)
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalTo(recordDateLabel.snp.bottom).offset(16)
    }
    
    mainImageView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
    }
  }
}
