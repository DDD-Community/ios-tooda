//
//  NoteDetailTextContentCell.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/22.
//

import UIKit

import SnapKit

final class NoteDetailTextContentCell: BaseTableViewCell {
  
  enum Font {
    static let content = TextStyle.body(color: .gray1)
  }
  
  // MARK: - UI Components

  private let descriptionLabel = UILabel().then {
    $0.numberOfLines = 0
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
  
  // MARK: - Overridden: ParentClass
  
  override func configureUI() {
    super.configureUI()
    contentView.addSubview(descriptionLabel)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    descriptionLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(15)
      $0.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  // MARK: - Internal methods
  
  func configure(content: String) {
    super.configure()
    descriptionLabel.attributedText = content.styled(with: Font.content)
  }
}
