//
//  CreateGuideView.swift
//  Tooda
//
//  Created by Lyine on 2021/12/12.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import Then

final class CreateGuideView: UIView {
  
  private(set) var didSetupConstraints = false
  
  private enum Font {
    static let date = TextStyle.subTitle(color: .gray1)
    static let description = TextStyle.body(color: .gray3)
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
    
    self.do {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 16
      $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      $0.layer.shadowColor = UIColor(hex: "#394B44").withAlphaComponent(0.12).cgColor
      $0.layer.shadowOffset = CGSize(width: 0, height: 8)
      $0.layer.shadowOpacity = 1
      $0.layer.shadowRadius = 40.0
    }
    
    self.titleLabel.do {
      $0.attributedText = Date().string(.dot).styled(with: Font.date)
    }
    
    self.addSubviews(titleLabel, descriptionContainerView)
    
    self.descriptionContainerView.addSubview(descriptionLabel)
  }
  
  private func setupConstraints() {
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
}
