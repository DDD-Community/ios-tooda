//
//  BaseTableViewCell.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

  private(set) var didSetupConstaints = false

  // MARK: Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Func

  override func updateConstraints() {
    if !self.didSetupConstaints {
      self.setupConstraints()
      self.didSetupConstaints = true
    }
    super.updateConstraints()
  }

  func configure() {
    self.setNeedsUpdateConstraints()
  }

  func configureUI() {}

  func setupConstraints() { }
}
