//
//  CreateNoteGuideView.swift
//  Tooda
//
//  Created by Lyine on 2021/12/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import Then
import SnapKit

protocol CreateNoteGuideViewDelegate: AnyObject {
  func contentDidTapped()
}

final class CreateNoteGuideView: UIView {
  
  private(set) var didSetupConstraints = false
  
  private enum Font {
    static let date = TextStyle.subTitle(color: .gray1)
    static let description = TextStyle.body(color: .gray3)
  }
  
  private enum Constants {
    static let gradientGrayColor = UIColor(hex: "#EDF0F0")
    static let shadowColor = UIColor(hex: "#394B44")
  }
  
  weak var delegate: CreateNoteGuideViewDelegate?
  
  let contentView = UIView().then {
    $0.layer.masksToBounds = false
  }
  
  private let titleLabel = UILabel().then {
    $0.textAlignment = .center
    $0.numberOfLines = 1
  }
  
  private let descriptionContainerView = UIView().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 8.0
    $0.layer.borderColor = UIColor.gray4.cgColor
    $0.layer.borderWidth = 1.0
  }
  
  private let descriptionLabel = UILabel().then {
    $0.attributedText = "✍️ 오늘의 투자 기록을 적어보세요.".styled(with: Font.description)
    $0.numberOfLines = 1
  }
  
  override init(frame: CGRect) {
    defer {
      self.configureUI()
      self.configureGesture()
    }
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateConstraints()
  }
  
  private func configureUI() {
    
    self.titleLabel.do {
      $0.attributedText = Date().string(.dot).styled(with: Font.date)
    }
    
    self.addSubview(contentView)
    
    self.contentView.addSubviews(titleLabel, descriptionContainerView)
    
    self.descriptionContainerView.addSubview(descriptionLabel)
  }
  
  private func setupConstraints() {
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.centerX.equalToSuperview()
    }
    
    descriptionContainerView.snp.makeConstraints {
      $0.top.equalTo(self.titleLabel.snp.bottom).offset(13)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(-61)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 12, left: 14, bottom: 10, right: 14))
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.applyGradientAndShadow(self.contentView)
  }
  
  private func configureGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewDidTapped))
    self.contentView.addGestureRecognizer(tapGesture)
  }
  
  @objc
  private func contentViewDidTapped(_ sender: Any?) {
    self.delegate?.contentDidTapped()
  }
  
  private func applyGradientAndShadow(_ view: UIView) {
    view.do {
      let gradient = $0.generateGradient(colors: [UIColor.white, Constants.gradientGrayColor])
      
      gradient.cornerRadius = 16
      gradient.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      
      gradient.makeShadow(color: Constants.shadowColor.withAlphaComponent(0.12),
                          radius: 40,
                          opacity: 1,
                          offset: CGSize(width: 0, height: 8))
      
      $0.layer.insertSublayer(gradient, at: 0)
    }
  }
}

// MARK: - Extensions

private extension CALayer {
  func makeShadow(color: UIColor, radius: CGFloat, opacity: Float, offset: CGSize) {
    self.masksToBounds = false
    self.shadowColor = color.cgColor
    self.shadowOpacity = opacity
    self.shadowOffset = offset
    self.shadowRadius = radius
  }
}
