//
//  NotebookCell.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/07/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import SnapKit

class NotebookCell: UICollectionViewCell {

  // MARK: Constants

  private enum Font {
    static let titleMonth = TextStyle.subTitleBold(color: .white)
    static let title = TextStyle.subTitle(color: .white)
    static let historyDate = TextStyle.caption(color: .white)
    static let emptyHistoryDate = TextStyle.caption(color: .gray1)
  }

  private enum Text {
    static let monthTitle = "{month}월"
    static let titleSuffix = "의 투다"
    static let historyDate = "{day}일 전에 살펴봤어요."
    static let emptyHistoryDate = "새로운 기록을 남겨보세요"
  }


  // MARK: ViewModel

  struct ViewModel {
    let month: String
    let backgroundImage: UIImage?
    let historyDate: String?
  }


  // MARK: UI

  private let backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }

  private let titleLabel = UILabel().then {
    $0.numberOfLines = 1
  }

  private let historyDateLabel = UILabel().then {
    $0.numberOfLines = 1
  }


  // MARK: Properties

  private(set) var viewModel: ViewModel?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.configureUI()
    self.configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configureUI() {
    self.backgroundColor = .black

    self.contentView.do {
      $0.addSubview(self.backgroundImageView)
      $0.addSubview(self.titleLabel)
      $0.addSubview(self.historyDateLabel)
    }
  }

  private func configureConstraints() {
    self.backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(22.0)
      $0.right.equalToSuperview().inset(22.0)
      $0.bottom.equalTo(self.historyDateLabel.snp.top).offset(-4.0)
    }

    self.historyDateLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(22.0)
      $0.right.equalToSuperview().inset(22.0)
      $0.bottom.equalToSuperview().inset(16.0)
    }
  }

  func configure(viewModel: ViewModel) {
    self.viewModel = viewModel
    print(Text.monthTitle.styled(with: Font.titleMonth).replace(key: "month", value: viewModel.month).string)
    self.titleLabel.attributedText = NSAttributedString.composed(
      of: [
        Text.monthTitle.styled(with: Font.titleMonth).replace(key: "month", value: viewModel.month),
        Text.titleSuffix.styled(with: Font.title)
      ]
    )
    self.backgroundImageView.image = viewModel.backgroundImage

    guard let historyDate = viewModel.historyDate else {
      self.historyDateLabel.attributedText = Text.emptyHistoryDate.styled(with: Font.emptyHistoryDate)
      return
    }
    self.historyDateLabel.attributedText = Text.historyDate.styled(with: Font.historyDate)
      .replace(key: "day", value: historyDate)
  }

}
