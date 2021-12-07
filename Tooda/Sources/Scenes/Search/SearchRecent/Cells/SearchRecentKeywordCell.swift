//
//  SearchRecentKeywordCell.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import SnapKit

final class SearchRecentKeywordCell: BaseCollectionViewCell {

  // MARK: Constants

  private enum Font {
    static let title = TextStyle.body2(color: .gray1)
  }


  // MARK: ViewModel

  struct ViewModel {
    let title: String
  }


  // MARK: UI

  private let clockImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(type: .iconHistory14)
  }

  private let titleLabel = UILabel().then {
    $0.numberOfLines = 1
    $0.textAlignment = .left
  }

  private let closeButton = UIButton().then {
    $0.setImage(
      UIImage(type: .iconCancelBlack),
      for: .normal
    )
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  override func configureUI() {
    super.configureUI()

    self.contentView.do {
      $0.addSubview(self.clockImageView)
      $0.addSubview(self.titleLabel)
      $0.addSubview(self.closeButton)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    self.clockImageView.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 14.0, height: 14.0))
      $0.left.equalToSuperview()
      $0.centerY.equalToSuperview()
    }

    self.titleLabel.snp.makeConstraints {
      $0.left.equalTo(self.clockImageView.snp.right).offset(10.0)
      $0.centerY.equalToSuperview()
    }

    self.closeButton.snp.makeConstraints {
      $0.size.equalTo(CGSize(width: 24.0, height: 24.0))
      $0.right.equalToSuperview()
      $0.left.equalTo(self.titleLabel.snp.right).offset(10.0)
    }
  }

  func configure(viewModel: ViewModel) {
    self.titleLabel.attributedText = viewModel.title.styled(with: Font.title)

    self.setNeedsUpdateConstraints()
  }

}
