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
import RxSwift
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
    static let imageViewSize: CGSize = CGSize(width: 74.0, height: 74.0)
    static let linkIconSize: CGSize = CGSize(width: 14.0, height: 14.0)
    static let lineViewWidth: CGFloat = 1.0
  }
  
  // MARK: UI Properties
  
  private let indcatorView = UIActivityIndicatorView()
  
  private let containerStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = UIColor.gray4.cgColor
    $0.layer.borderWidth = 1.0
    $0.clipsToBounds = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let placeHolderView = ImagePlaceHolderView(image: UIImage(type: .iconImagePlaceHolder))
  
  private let thumnailView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  private let lineView = UIView().then {
    $0.backgroundColor = UIColor.gray4
  }
  
  private let infoStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalCentering
    $0.alignment = .leading
    $0.layoutMargins = UIEdgeInsets(top: 8.5, left: 16, bottom: 7.5, right: 15)
    $0.isLayoutMarginsRelativeArrangement = true
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private let titleStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fill
    $0.spacing = 3.94
  }

  private let linkIconView = UIImageView(image: UIImage(type: .link)).then {
    $0.contentMode = .scaleAspectFit
  }
  
  private let titleLabel = MarginLabel(edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)).then {
    $0.numberOfLines = Const.labelLineNumbers
    $0.verticalAlignment = .top
  }
  
  private let descriptionLabel = UILabel().then {
    $0.numberOfLines = Const.labelLineNumbers
  }
  
  private let canonicalLabel = UILabel().then {
    $0.numberOfLines = Const.labelLineNumbers
  }
  
  let button = UIButton()
  
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
    
    self.contentView.addSubviews(containerStackView, button, indcatorView)
    
    [thumnailView, lineView, infoStackView].forEach {
      self.containerStackView.addArrangedSubview($0)
    }
    
    [placeHolderView].forEach {
      self.thumnailView.addSubview($0)
    }
    
    [titleStackView, descriptionLabel, canonicalLabel].forEach {
      self.infoStackView.addArrangedSubview($0)
    }

    [linkIconView, titleLabel].forEach {
      self.titleStackView.addArrangedSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    indcatorView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    containerStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }
    
    button.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }   
    
    thumnailView.snp.makeConstraints {
      $0.size.equalTo(Metric.imageViewSize)
    }
    
    placeHolderView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    lineView.snp.makeConstraints {
      $0.width.equalTo(Metric.lineViewWidth)
    }
        
    linkIconView.snp.makeConstraints {
      $0.size.equalTo(Metric.linkIconSize)
    }
  }

  func bind(reactor: Reactor) {
    
    Observable.just(())
      .map { Reactor.Action.fetchLink }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.isLoading }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        self?.indicatorViewDidChanged(by: $0)
      })
      .disposed(by: self.disposeBag)
    
    reactor.state
      .compactMap { $0.response }
      .subscribeOn(MainScheduler.asyncInstance)
      .subscribe(onNext: { [weak self] in
        self?.fetchLinkData($0)
      }).disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.hasNotTitle }
      .asDriver(onErrorJustReturn: true)
      .drive(onNext: { [weak self] in
        self?.subViewsVisibilityDidChanged(by: $0)
      }).disposed(by: self.disposeBag)
  }
}

// MARK: - Extension

extension NoteLinkCell {
  private func fetchLinkData(_ response: LinkPreviewResponse?) {
    guard let response = response else {
      return
    }
    
    
    DispatchQueue.main.async { [weak self] in
      if let url = response.imageURL {
        self?.thumnailView.image = url.urlImage
        self?.placeHolderView.isHidden = true
      } else {
        self?.placeHolderView.isHidden = false
      }
    }
    
    self.thumnailView.image = response.imageURL?.urlImage
    self.titleLabel.attributedText = response.title?.styled(with: Font.title)
    self.canonicalLabel.attributedText = response.canonicalUrl?.styled(with: Font.caption)
    self.descriptionLabel.attributedText = response.description?.styled(with: Font.caption)
  }
  
  private func subViewsVisibilityDidChanged(by hasNotTitle: Bool) {
    self.linkIconView.isHidden = hasNotTitle
    self.lineView.isHidden = hasNotTitle
  }
  
  private func indicatorViewDidChanged(by isLoading: Bool) {
    if isLoading {
      self.indcatorView.startAnimating()
    } else {
      self.indcatorView.stopAnimating()
    }
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: NoteLinkCell {
  var itemDidTapped: Observable<String> {
    return self.base.button.rx.tap.flatMap { [weak base] _ -> Observable<String> in
      let urlString = base?.reactor?.payload ?? ""
      return .just(urlString)
    }
  }
}
