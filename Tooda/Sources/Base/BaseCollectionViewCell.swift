//
//  BaseCollectionViewCell.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
  
  private(set) var didSetupConstraints = false
  
  // MARK: Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Func
  
  override func updateConstraints() {
    if !self.didSetupConstraints {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateConstraints()
  }
  
  func configure() {
    self.setNeedsUpdateConstraints()
  }
  
  func configureUI() {}
  
  func setupConstraints() {}
}
