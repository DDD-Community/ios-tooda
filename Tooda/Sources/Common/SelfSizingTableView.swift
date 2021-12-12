//
//  SelfSizingTableView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class SelfSizingTableView: UITableView {
  override var intrinsicContentSize: CGSize {
    return contentSize
  }
}
