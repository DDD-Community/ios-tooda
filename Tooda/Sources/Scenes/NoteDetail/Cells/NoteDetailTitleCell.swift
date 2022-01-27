//
//  NoteDetailTitleCell.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/22.
//

import UIKit

final class NoteDetailTitleCell: BaseTableViewCell {
  
  enum Font {
    static let title = TextStyle.titleBold(color: .gray1)
    static let dateInfo = TextStyle.captionBold(color: .gray1)
  }
  
  // MARK: - UI Components

  private let titleLabel = UILabel()
  
  private let dateLabel = UILabel()
  
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
  
  // MARK: - Overridden: ParentClass
  
  override func configureUI() {
    super.configureUI()
    contentView.addSubviews(
      titleLabel,
      dateLabel
    )
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(1)
      $0.leading.trailing.equalToSuperview().inset(19)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview().inset(19)
      $0.bottom.equalToSuperview().inset(15)
    }
  }
  
  // MARK: - Internal methods
  
  func configure(title: String?, date: String?) {
    if let title = title {
      titleLabel.attributedText = title.styled(with: Font.title)
    }
    
    if let dateString = date {
      dateLabel.attributedText = dateString.styled(with: Font.dateInfo)
    }
  }
}
