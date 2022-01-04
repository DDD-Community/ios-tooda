//
//  OneLineReviewOptionCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class OneLineReviewOptionCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  private enum Font {
    static let title = TextStyle.body(color: .gray1)
  }
  
  // MARK: - UI Components
  
  private let cardView = UIView().then {
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.gray5.cgColor
    $0.layer.cornerRadius = 8
  }
  
  private let emojiImageView = UIImageView()
  
  private let titleLabel = UILabel()
  
  // MARK: - Overridden: ParentClass
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    configureSelected(isSelected: selected)
  }
  
  override func configureUI() {
    super.configureUI()
    contentView.do {
      $0.backgroundColor = .white
      $0.addSubview(cardView)
    }
    
    cardView.addSubviews(
      emojiImageView,
      titleLabel
    )
  }

  override func setupConstraints() {
    super.setupConstraints()
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
  
  func configure(sticker: Sticker) {
    super.configure()
    emojiImageView.image = sticker.image
    titleLabel.attributedText = sticker.optionTitle.styled(with: Font.title)
  }
  
  // MARK: - Private methods
  
  private func configureSelected(isSelected: Bool) {
    if isSelected {
      cardView.backgroundColor = .subGreen
      cardView.layer.borderColor = UIColor.mainGreen.cgColor
    } else {
      cardView.backgroundColor = .white
      cardView.layer.borderColor = UIColor.gray5.cgColor
    }
  }
}
