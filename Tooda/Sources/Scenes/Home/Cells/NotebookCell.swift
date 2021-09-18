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
    static let emptyTitleMonth = TextStyle.subTitleBold(color: .gray1)
    static let title = TextStyle.subTitle(color: .white)
    static let emptyTitle = TextStyle.subTitle(color: .gray1)
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
    let stickers: [UIImage?]
    let isPlaceholder: Bool
  }


  // MARK: Sticker Location

  private enum StickerIndex: Int {
    case first
    case second
    case third
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

  private var stickers: [UIImageView] = []


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
    self.backgroundColor = .clear

    self.contentView.do {
      $0.addSubview(self.backgroundImageView)
      $0.addSubview(self.titleLabel)
      $0.addSubview(self.historyDateLabel)
    }

    for _ in 0..<3 {
      let sticker = UIImageView().then { $0.contentMode = .scaleAspectFit }
      self.stickers.append(sticker)
      self.contentView.addSubview(sticker)
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

    self.stickers.enumerated().forEach { (offset, item) in
      guard let index = StickerIndex(rawValue: offset) else { return }

      switch index {
      case .first:
        item.snp.makeConstraints {
          $0.size.equalTo(CGSize(width: 40.0, height: 40.0))
          $0.top.equalToSuperview().inset(30.0)
          $0.right.equalToSuperview().inset(80.0)
        }

      case .second:
        item.snp.makeConstraints {
          $0.size.equalTo(CGSize(width: 40.0, height: 40.0))
          $0.top.equalToSuperview().inset(60.0)
          $0.right.equalToSuperview().inset(30.0)
        }

      case .third:
        item.snp.makeConstraints {
          $0.size.equalTo(CGSize(width: 40.0, height: 40.0))
          $0.top.equalToSuperview().inset(120.0)
          $0.right.equalToSuperview().inset(50.0)
        }
      }
    }
  }

  func configure(viewModel: ViewModel) {
    self.viewModel = viewModel
    self.titleLabel.attributedText = NSAttributedString.composed(
      of: [
        Text.monthTitle
          .styled(with: viewModel.isPlaceholder ? Font.emptyTitleMonth : Font.titleMonth)
          .replace(key: "month", value: viewModel.month),
        Text.titleSuffix.styled(with: viewModel.isPlaceholder ? Font.emptyTitle : Font.title)
      ]
    )
    self.backgroundImageView.image = viewModel.backgroundImage
    viewModel.stickers.enumerated().forEach {
      self.stickers[$0.offset].image = $0.element
    }

    guard let historyDate = viewModel.historyDate else {
      self.historyDateLabel.attributedText = Text.emptyHistoryDate.styled(with: Font.emptyHistoryDate)
      return
    }
    self.historyDateLabel.attributedText = Text.historyDate.styled(with: Font.historyDate)
      .replace(key: "day", value: historyDate)
  }
}
