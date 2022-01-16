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
import UITextView_Placeholder

class NoteContentCell: BaseTableViewCell, View {
  typealias Reactor = NoteContentCellReactor

  var disposeBag: DisposeBag = DisposeBag()
  
  private enum Const {
    static let baseColor: UIColor = UIColor.gray3
    
    static let baseTextColor: UIColor = UIColor.gray1
    
    static let maximumTitleTextLength: Int = 35
    static let maximumContnetTextLenght: Int = 2000
    
    static let titlePlaceHolderStyledText = "제목을 입력해 주세요. (최대 \(maximumTitleTextLength) 자)".styled(with: TextStyle.body(color: baseColor))
    static let contentPlaceHolderStyledText = "오늘 알게된 투자 정보, 매매 기록 등을 입력해보세요.\n(최대 \(maximumContnetTextLenght)자)".styled(with: TextStyle.body(color: baseColor))
  }

  private let titleTextFieldBackgroundView = UIView().then {
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = UIColor.gray4.cgColor
    $0.layer.borderWidth = 1.0
  }
  
  let titleTextField = UITextField().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
    $0.textColor = Const.baseTextColor
    $0.attributedPlaceholder = Const.titlePlaceHolderStyledText
  }

  private let contentTextViewBackGroundView = UIView().then {
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = UIColor.gray4.cgColor
    $0.layer.borderWidth = 1.0
  }

  let contentTextView = UITextView().then {
    $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    $0.textColor = Const.baseTextColor
    $0.textAlignment = .left
    $0.attributedPlaceholder = Const.contentPlaceHolderStyledText
  }

  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
    
    self.titleTextField.delegate = self
    self.contentTextView.delegate = self
  }
  
  // MARK: Cell Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override func configureUI() {
    super.configureUI()

    [titleTextFieldBackgroundView, contentTextViewBackGroundView].forEach {
      self.contentView.addSubview($0)
    }
    
    [titleTextField].forEach {
      self.titleTextFieldBackgroundView.addSubview($0)
    }
    
    [contentTextView].forEach {
      self.contentTextViewBackGroundView.addSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()

    titleTextFieldBackgroundView.snp.makeConstraints {
      $0.top.left.right.width.equalToSuperview()
      $0.height.equalTo(43)
    }
    
    titleTextField.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 14, bottom: 10, right: 14))
    }
    
    contentTextViewBackGroundView.snp.makeConstraints {
      $0.top.equalTo(titleTextFieldBackgroundView.snp.bottom).offset(10)
      $0.left.right.bottom.width.equalToSuperview()
      $0.height.equalTo(169)
    }
    
    contentTextView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 9, bottom: 10, right: 9))
    }
  }

  func bind(reactor: Reactor) {

    reactor.state
      .map { $0.payload }
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: .init(title: "", content: ""))
      .drive(onNext: { [weak self] in
        self?.titleTextField.text = $0.title
        self?.contentTextView.text = $0.content
      })
      .disposed(by: self.disposeBag)
  }
}

// MARK: - Extensions

extension NoteContentCell: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return TextInputLimiter(maxLength: Const.maximumTitleTextLength)
      .shouldTextInMaxLength(propertyValue: textField.text, range: range, replace: string)
  }
}

extension NoteContentCell: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    return TextInputLimiter(maxLength: Const.maximumContnetTextLenght)
      .shouldTextInMaxLength(propertyValue: textView.text, range: range, replace: text)
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: NoteContentCell {
  var combinedTextDidChanged: Observable<(String, String)> {
    return Observable.combineLatest(
      self.base.titleTextField.rx.text.orEmpty.asObservable(),
      self.base.contentTextView.rx.text.orEmpty.asObservable()
    )
  }
}
