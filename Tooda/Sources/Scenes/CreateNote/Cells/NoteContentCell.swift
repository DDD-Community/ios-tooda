//
//  NoteContentCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit
import Then

class NoteContentCell: BaseTableViewCell, View {
  typealias Reactor = NoteContentCellReactor

  var disposeBag: DisposeBag = DisposeBag()
  
  private enum Constants {
    static let baseColor: UIColor = UIColor.gray3
    
    static let baseTextColor: UIColor = UIColor.gray1
    
    static let maximumTitleTextLength: Int = 35
    static let maximumContnetTextLenght: Int = 2000
    
    static let titlePlaceHolderStyledText = "제목을 입력해 주세요. (최대 \(maximumTitleTextLength) 자)".styled(with: TextStyle.body(color: baseColor))
    static let contentPlaceHolderStyledText = "오늘 알게된 투자 정보, 매매 기록 등을 입력해보세요.\n(최대 \(maximumContnetTextLenght)자)".styled(with: TextStyle.body(color: baseColor))
  }

  let titleTextField = BolderTextField(frame: .zero).then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.textColor = UIColor(type: .gray3)
    $0.attributedPlaceholder = Constants.titlePlaceHolderStyledText
    $0.layer.borderColor = Constants.baseColor.cgColor
    $0.layer.cornerRadius = 8.0
  }

  let contentTextFieldBackgroundView = UIView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = Constants.baseColor.cgColor
    $0.layer.borderWidth = 1.0
  }

  let contentTextField = UITextField().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    $0.textColor = Constants.baseColor
    $0.contentVerticalAlignment = .top
    $0.attributedPlaceholder = Constants.contentPlaceHolderStyledText
  }

  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
  
  // MARK: Cell Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override func configureUI() {
    super.configureUI()

    [titleTextField, contentTextFieldBackgroundView].forEach {
      self.contentView.addSubview($0)
    }

    [contentTextField].forEach {
      self.contentTextFieldBackgroundView.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    titleTextField.snp.makeConstraints {
      $0.top.left.right.width.equalToSuperview()
      $0.height.equalTo(43)
    }

    contentTextFieldBackgroundView.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(10)
      $0.left.right.bottom.width.equalToSuperview()
      $0.height.equalTo(169)
    }

    contentTextField.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.left.equalToSuperview().offset(14)
      $0.right.equalToSuperview().offset(-14)
      $0.bottom.equalToSuperview().offset(-16)
    }
  }

  func bind(reactor: Reactor) {

  }
}
