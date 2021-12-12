//
//  SearchRecentTitleCell.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import SnapKit

protocol SearchRecentTitleCellDelegate: AnyObject {
  func didTapRemoveAll(_ sender: SearchRecentTitleCell)
}

final class SearchRecentTitleCell: BaseCollectionViewCell {

  // MARK: Constants

  private enum Font {
    static let title = TextStyle.bodyBold(color: .gray1)
    static let removeAll = TextStyle.body(color: .gray2)
  }


  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.attributedText = "최근 검색어".styled(with: Font.title)
  }

  private let removeAllButton = UIButton().then {
    $0.setAttributedTitle(
      "모두 지우기".styled(with: Font.removeAll),
      for: .normal
    )
  }


  // MARK: Properties

  weak var delegate: SearchRecentTitleCellDelegate?

  override func configureUI() {
    super.configureUI()

    self.contentView.do {
      $0.addSubview(self.titleLabel)
      $0.addSubview(self.removeAllButton)
    }

    self.removeAllButton.addTarget(
      self,
      action: #selector(self.didTapRemoveAll),
      for: .touchUpInside
    )
  }

  override func setupConstraints() {
    super.setupConstraints()

    self.titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.right.equalTo(self.removeAllButton.snp.right).offset(10.0)
    }

    self.removeAllButton.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.top.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}


// MARK: - Action

extension SearchRecentTitleCell {

  @objc private func didTapRemoveAll() {
    self.delegate?.didTapRemoveAll(self)
  }
}
