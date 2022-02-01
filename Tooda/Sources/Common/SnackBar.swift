//
//  SnackBar.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/30.
//

import UIKit

import SnapKit
import Then

final class SnackBar: UIView {
  
  // MARK: - Constants
  
  enum Font {
    static let title = TextStyle.bodyBold(color: .gray1)
  }
  
  // MARK: - UI Components
  
  private let stickerImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 0
  }
  
  // MARK: - Con(De)structor

  init(type: SnackBarType) {
    super.init(frame: .zero)
    setupUI()
    baseConfigure(type: type)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private methods
  
  private func baseConfigure(type: SnackBarType) {
    self.do {
      $0.backgroundColor = type.backgroundColor
      $0.layer.cornerRadius = 8
    }
    
    stickerImageView.image = type.emojiImage
  }
  
  // MARK: - Internal methods
  
  func setTitle(with title: String) {
    titleLabel.attributedText = title.styled(with: Font.title)
  }
}

// MARK: - SetupUI
private extension SnackBar {
  func setupUI() {
    addSubviews(
      stickerImageView,
      titleLabel
    )
    
    stickerImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(16)
      $0.width.height.equalTo(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(stickerImageView.snp.trailing).offset(10)
      $0.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().inset(14)
      $0.bottom.equalToSuperview().inset(13)
    }
  }
}
