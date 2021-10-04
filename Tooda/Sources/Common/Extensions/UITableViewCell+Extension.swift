//
//  UITableViewCell+Extension.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

// MARK: UITableViewCell
extension UITableViewCell: CellType {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UITableViewHeaderFooterView: ViewType, CellType {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

// MARK: Cell

extension UITableView {
  func dequeue<T>(_ cellType: T.Type, indexPath: IndexPath) -> T where T: CellType {
    return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func dequeue<T>(_ cellType: T.Type) -> T where T: CellType {
    return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier) as! T
  }
  
  func register<T>(_ cellType: T.Type) where T: CellType {
    self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
  }
}

// MARK: Header & FotterView

extension UITableView {
  func dequeue<T>(_ cellType: T.Type, indexPath: IndexPath) -> T where T: CellType, T: ViewType {
    return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
  }
  
  func register<T>(_ cellType: T.Type) where T: CellType, T: ViewType {
    self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
  }
}
