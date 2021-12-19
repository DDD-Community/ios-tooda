//
//  NoteLinkCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import Then
import ReactorKit
import SnapKit

class NoteLinkCell: BaseTableViewCell, View {
  typealias Reactor = NoteLinkCellReactor

  var disposeBag: DisposeBag = DisposeBag()
  
  private enum Const {
    static let labelLineNumbers = 1
  }
  
  private enum Font {
    static let title = TextStyle.bodyBold(color: .gray1)
    static let caption = TextStyle.caption(color: .gray3)
  }
  
  private enum Metric {
    static let imageViewHeight: CGFloat = 94.0
    static let linkIconSize: CGSize = CGSize(width: 14.0, height: 14.0)
  }
  
  // MARK: UI Properties
  
  private let containerStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.layer.cornerRadius = 8.0
    $0.clipsToBounds = true
    $0.layer.borderColor = UIColor.gray4.cgColor
    $0.layer.borderWidth = 1.0
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let imageContentView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
  }
  
  private let linkInfoStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
    $0.layoutMargins = UIEdgeInsets(top: 8.5, left: 16, bottom: 7.5, right: 15)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let linkContainerView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.spacing = 3.94
    $0.translatesAutoresizingMaskIntoConstraints = false
  }

  private let linkIconView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let linkTitleLabel = UILabel().then {
    $0.numberOfLines = Const.labelLineNumbers
  }
  
  private let descriptionCaptionLabel = UILabel().then {
    $0.numberOfLines = Const.labelLineNumbers
  }
  
  private let linkCaptionLabel = UILabel().then {
    $0.numberOfLines = Const.labelLineNumbers
  }
  
  // MARK: Cell Life Cycle
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func configureUI() {
    super.configureUI()
    
    self.addSubview(containerStackView)
    
    [imageContentView, linkInfoStackView].forEach {
      self.containerStackView.addArrangedSubview($0)
    }
    
    [linkContainerView, descriptionCaptionLabel, linkCaptionLabel].forEach {
      self.linkInfoStackView.addArrangedSubview($0)
    }
    
    [linkIconView, linkTitleLabel].forEach {
      self.linkContainerView.addArrangedSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Metric.imageViewHeight)
    }
    
    imageContentView.snp.makeConstraints {
      $0.width.equalTo(Metric.imageViewHeight)
    }
    
    linkIconView.snp.makeConstraints {
      $0.size.equalTo(Metric.linkIconSize)
    }
    
    imageContentView.setContentHuggingPriority(.required, for: .horizontal)
    imageContentView.setContentHuggingPriority(.required, for: .vertical)
  }

  func bind(reactor: Reactor) {

  }
}
