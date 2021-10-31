//
//  MarginLabel.swift
//  Tooda
//
//  Created by 황재욱 on 2021/10/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

final class MarginLabel: UILabel {
  
  // MARK: - Types
  
  enum VerticalAlignment {
    case top
    case bottom
    case middle
    case none
  }
  
  // MARK: - Properties
  
  private let edgeInsets: UIEdgeInsets
  
  var verticalAlignment: VerticalAlignment = .none {
    didSet {
      self.setNeedsDisplay()
    }
  }
  
  // MARK: - Constructor
  
  init(edgeInsets: UIEdgeInsets) {
    self.edgeInsets = edgeInsets
    super.init(frame: .zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overridden: ParentClass
  
  override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(width: size.width + edgeInsets.left + edgeInsets.right,
                  height: size.height + edgeInsets.top + edgeInsets.bottom)
  }
  
  override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
    var textRect:CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
    
    switch self.verticalAlignment {
    case .top:
      textRect.origin.y = bounds.origin.y
    case .bottom:
      textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
    case .middle:
      textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
    case .none:
      break
    }
    
    return textRect
  }
  
  override func drawText(in rect: CGRect) {
    if verticalAlignment == .none {
      super.drawText(in: rect.inset(by: edgeInsets))
    } else {
      let actualRect = self.textRect(
        forBounds: rect,
        limitedToNumberOfLines: self.numberOfLines
      )
      super.drawText(in: actualRect)
    }
  }
}
