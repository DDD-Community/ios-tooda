//
//  BaseTableHeaderView.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class BaseTableHeaderView: UITableViewHeaderFooterView {
  private(set) var didSetupConstraints = false

  override func updateConstraints() {
    if self.didSetupConstraints == false {
      self.setupConstraints()
      self.didSetupConstraints = true
    }
    super.updateConstraints()
  }

  func configure() {
    self.setNeedsUpdateConstraints()
  }

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  func configureUI() { }
  func setupConstraints() { }
}
