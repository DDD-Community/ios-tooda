//
//  NoteStickerCell.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/22.
//

import UIKit

final class NoteStickerCell: BaseTableViewCell {
  
  private let stickerImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = UILabel()

  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(
      style: style,
      reuseIdentifier: reuseIdentifier
    )
  }
  
  func configure() {
    
  }
  
  override func configureUI() {
    super.configureUI()
    contentView.addSubviews(
      stickerImageView,
      titleLabel
    )
    
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    stickerImageView
  }
}
