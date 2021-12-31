//
//  SearchResultEmptyView.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/12/31.
//

import UIKit

import Then
import SnapKit

final class SearchResultEmptyView: UIView {

  // MARK: Constants

  private enum Font {
    static let title = TextStyle.body(color: .gray1)
    static let titleBold = TextStyle.bodyBold(color: .gray1)
  }

  // MARK: UI

  private let emojiImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = UIImage(type: .emojiToodaGray)
  }

  private let titleLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.textAlignment = .center
    $0.attributedText = NSAttributedString.composed(
      of: [
        "음.. 그런 내용은 적지 않았어요!\n"
          .styled(with: Font.title)
          .alignment(with: .center),
        "다시 검색해보세요."
          .styled(with: Font.titleBold)
          .alignment(with: .center)
      ]
    )
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .gray5
    self.configureUI()
    self.configureConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configureUI() {
    self.do {
      $0.addSubview(self.emojiImageView)
      $0.addSubview(self.titleLabel)
    }
  }

  private func configureConstraints() {
    self.emojiImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(self.titleLabel.snp.top).offset(-8.0)
    }

    self.titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(16.0)
      $0.right.equalToSuperview().inset(16.0)
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview().offset(-6.0)
    }
  }
}
