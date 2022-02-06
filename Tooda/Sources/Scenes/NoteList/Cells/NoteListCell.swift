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
  
  enum Constants {
    static let sideMargins: CGFloat = 80
  }
  
  enum Font {
    static let title = TextStyle.subTitleBold(color: .gray1)
    static let recordDate = TextStyle.captionBold(color: .gray3)
    static let description = TextStyle.body(color: .gray1)
    static let imageCount = TextStyle.caption(color: .gray2)
  }
  
  // MARK: - UI Components
  
  private let cardView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 8
    $0.configureShadow(
      color: UIColor.gray6.withAlphaComponent(0.12),
      alpha: 1,
      x: 0,
      y: 8,
      blur: 40,
      spread: 0
    )
  }
  
  private let emojiImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = UILabel()
  
  private let recordDateLabel = UILabel()
  
  private let linkImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(type: .iconLinkChain)
    $0.isHidden = true
  }
  
  private let descriptionLabel = UILabel().then {
    $0.numberOfLines = 4
  }
  
  private let mainImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }
  
  private let imageCountLabel = MarginLabel(
    edgeInsets: UIEdgeInsets(horizontal: 8, vertical: 2)
  ).then {
    $0.layer.cornerRadius = 8
    $0.backgroundColor = .white
    $0.clipsToBounds = true
  }
  
  // MARK: - Overridden: ParentClass
  
  override func configureUI() {
    super.configureUI()
    backgroundColor = .clear
    contentView.do {
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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    mainImageView.image = nil
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
    
    linkImageView.snp.makeConstraints {
      $0.leading.equalTo(recordDateLabel.snp.trailing).offset(6)
      $0.centerY.equalTo(recordDateLabel)
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
    selectionStyle = .none
    emojiImageView.image = note.sticker?.image
    titleLabel.attributedText = note.title.styled(with: Font.title)
    if let date = note.createdAt,
       let weekName = Date.WeekDay(rawValue: date.weekday)?.name {
      
      recordDateLabel.attributedText = "\(date.string(.dot)) (\(weekName)) \(date.hour):\(date.minute) 기록".styled(with: Font.recordDate)
    }
    
    linkImageView.isHidden = note.noteLinks?.first == nil ? true : false
    descriptionLabel.attributedText = note.content.styled(with: Font.description).alignment(with: .left)
    updateImages(images: note.noteImages)
    
    if note.noteImages.count > 1 {
      imageCountLabel.isHidden = false
      imageCountLabel.attributedText = "+ \(note.noteImages.count)".styled(with: Font.imageCount)
    } else {
      
      imageCountLabel.isHidden = true
    }
    
    DispatchQueue.main.async {
      self.descriptionLabel.setExpandActionIfPossible("더보기")
    }
  }
  
  // MARK: - Private methods
  
  private func updateImages(images: [NoteImage]) {
    
    if images.isEmpty {
      mainImageView.snp.remakeConstraints {
        $0.leading.trailing.equalToSuperview().inset(20)
        $0.top.equalTo(descriptionLabel.snp.bottom).offset(0)
        $0.bottom.equalToSuperview().inset(24)
      }
    } else {
      if let width = images.first?.width,
         let height = images.first?.height {
        let ratio: CGFloat = (UIScreen.main.bounds.width - Constants.sideMargins) / CGFloat(width)
        
        let calculatedHeight = CGFloat(height) * ratio
        
        mainImageView.snp.remakeConstraints {
          $0.leading.trailing.equalToSuperview().inset(20)
          $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
          $0.bottom.equalToSuperview().inset(24)
          $0.height.equalTo(calculatedHeight)
        }
      }
    }
    
    if let urlString = images.first?.imageURL,
       let url = URL(string: urlString) {
      mainImageView.load(url: url)
    }
  }
}
