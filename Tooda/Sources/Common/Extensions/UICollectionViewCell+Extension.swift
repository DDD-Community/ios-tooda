//
//  UICollectionViewCell+Extension.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

public enum SupplementaryViewKind: String {
  case header, footer
  
  public init?(rawValue: String) {
    switch rawValue {
      case UICollectionView.elementKindSectionHeader: self = .header
      case UICollectionView.elementKindSectionFooter: self = .footer
      default: return nil
    }
  }
  
  public var rawValue: String {
    switch self {
      case .header: return UICollectionView.elementKindSectionHeader
      case .footer: return UICollectionView.elementKindSectionFooter
    }
  }
}

protocol CellType: AnyObject {
  static var reuseIdentifier: String { get }
}

protocol ViewType: AnyObject {}

// MARK: UICollectionViewCell
extension UICollectionViewCell: CellType {
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}

extension UICollectionReusableView: ViewType {}

// MARK: Cell

extension UICollectionView {
  func dequeue<T>(_ cellType: T.Type, indexPath: IndexPath) -> T where T: CellType {
    return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func register<T>(_ cellType: T.Type) where T: CellType {
    self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
  }
}

// MARK: Header & FooterView

extension UICollectionView {
  func dequeue<T>(_ cellType: T.Type, kind: SupplementaryViewKind, indexPath: IndexPath) -> T where T: CellType, T: ViewType {
    return self.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
  }
  
  func register<T>(_ cellType: T.Type, kind: SupplementaryViewKind) where T: CellType, T: ViewType {
    self.register(T.self, forSupplementaryViewOfKind: kind.rawValue, withReuseIdentifier: T.reuseIdentifier)
  }
}

// MARK: Get Current indexPath

extension UICollectionViewCell {
  
  var collectionView: UICollectionView? {
    return superview as? UICollectionView
  }
  
  var indexPath: IndexPath? {
    return collectionView?.indexPath(for: self)
  }
  
}
