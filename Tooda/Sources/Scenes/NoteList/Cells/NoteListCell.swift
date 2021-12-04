//
//  NoteListCell.swift
//  Tooda
//
//  Created by 황재욱 on 2021/10/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import SnapKit

final class NoteListCell: BaseTableViewCell {
  
  // MARK: - Constants
  
  enum Font {
    static let title = TextStyle.subTitleBold(color: .gray1)
    static let recordDate = TextStyle.captionBold(color: .gray3)
    static let description = TextStyle.bodyBold(color: .gray1)
  }
  
  // MARK: - UI Components
  
  private let cardView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 8
    $0.layer.shadowOffset = CGSize(width: 0, height: 8)
    $0.layer.shadowOpacity = 1
    $0.layer.shadowRadius = 20
    $0.layer.shadowColor = UIColor.gray6.withAlphaComponent(0.12).cgColor
  }
  
  private let emojiImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = UILabel()
  
  private let recordDateLabel = UILabel()
  
  private let linkImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let descriptionLabel = UILabel().then {
    $0.numberOfLines = 4
  }
  
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 8
  }
  
  private let imageCountLabel = MarginLabel(
    edgeInsets: UIEdgeInsets(horizontal: 8, vertical: 2)
  ).then {
    $0.layer.cornerRadius = 8
  }
  
  // MARK: - Overridden: ParentClass
  
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
      linkImageView,
      descriptionLabel,
      mainImageView
    )
    
    mainImageView.addSubview(imageCountLabel)
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
      $0.bottom.equalToSuperview().inset(24)
    }
    
    imageCountLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(8)
      $0.trailing.equalToSuperview().inset(10)
    }
  }
  
  // MARK: - Internal methods
  
  func configure(with note: Note) {
    super.configure()
    emojiImageView.image = note.sticker?.image
    titleLabel.attributedText = note.title.styled(with: Font.title)
    recordDateLabel.attributedText = "\(note.createdAt) 기록".styled(with: Font.recordDate)
    descriptionLabel.attributedText = note.content.styled(with: Font.description)
    updateImages(images: note.noteImages)
    
    DispatchQueue.main.async {
      self.descriptionLabel.setExpandActionIfPossible("더보기")
    }
  }
  
  // MARK: - Private methods
  
  private func updateImages(images: [NoteImage]) {
    
    if images.isEmpty {
      mainImageView.snp.makeConstraints {
        $0.top.equalTo(descriptionLabel.snp.bottom).offset(0)
        $0.bottom.equalToSuperview().inset(0)
      }
    } else {
      mainImageView.snp.makeConstraints {
        $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        $0.bottom.equalToSuperview().inset(24)
      }
    }
    
    mainImageView.image = images.first?.imageURL.urlImage
  }
}
