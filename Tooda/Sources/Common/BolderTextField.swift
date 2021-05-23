//
//  BolderTextField.swift
//  Tooda
//
//  Created by Lyine on 2021/05/22.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class BolderTextField: UITextField {

  var inset: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
//	var focusedBorderColor: UIColor = UIColor(r: 255, g: 219, b: 0)
  var defaultBorderColor: UIColor = UIColor(r: 44, g: 55, b: 68, a: 0.1)
  var placeholderColor: UIColor = UIColor(r: 218, g: 218, b: 218)

  //TODO: X 버튼 만들기

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configureUI()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configureUI()
  }

  func configureUI() {
    self.configureTextField()
  }

  // A suffix string that will appear just to the right of visible text
  public var suffix: String? {
    didSet {
      setNeedsDisplay()
    }
  }

  // A prefix string that will appear just to the left of visible text
  public var prefix: String? {
    didSet {
      setNeedsDisplay()
    }
  }

  // Color for the suffix, default to the same color as the text
  public var suffixTextColor: UIColor?

  // Color for the prefix, default to the same color as the text
  public var prefixTextColor: UIColor?

  // Fallback text color
  private let placeHolderTextColor = UIColor(red: 120 / 255.0, green: 120 / 255.0, blue: 120 / 255.0, alpha: 1)

  private func centerWithPrefix(offset: CGFloat) {
    self.layer.sublayerTransform = CATransform3DMakeTranslation(offset, 0, 0)
  }

  override open func willMove(toSuperview newSuperview: UIView!) {
    if newSuperview != nil {
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)

      NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
    }
  }

  fileprivate func configureTextField() {
    clipsToBounds = false
    // Only draw suffix when we have a suffix and a text
    if (self.suffix ?? "").isEmpty == false && (text ?? "").isEmpty == false {
      
      // We use some handy methods on NSString
      let text = (self.text ?? "") as NSString
      
      // The x position of the suffix
      var suffixXPosition: CGFloat = 0
      
      // Spacing between suffix and text
      let spacing: CGFloat = 3.0
      
      // Font and color for the suffix
      let color = self.suffixTextColor ?? self.textColor ?? self.placeHolderTextColor
      let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): self.font!, NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
      
      // Calc the x position of the suffix
      if textAlignment == .center {
        let fieldWidth = frame.size.width
        let textWidth = text.size(withAttributes: attrs).width
        suffixXPosition = (fieldWidth / 2) + (textWidth / 2)
      } else {
        suffixXPosition = text.size(withAttributes: attrs).width
      }
      
      // Calc the rect to draw the suffix in
      let height = text.size(withAttributes: attrs).height
      let verticalCenter = height / 2.0
      let top: CGFloat = frame.size.height / 2 - ceil(verticalCenter)
      
      let width = (self.suffix! as NSString).size(withAttributes: attrs).width
      let offset = (width + spacing) / 2
      let rect = CGRect(x: suffixXPosition + spacing + offset, y: top, width: width, height: height)
      
      // Draw it
      (self.suffix! as NSString).draw(in: rect, withAttributes: attrs)
    }
    
    // Only prefix when we have a prefix and a text
    if (self.prefix ?? "").isEmpty == false && (text ?? "").isEmpty == false {
      
      // We use some handy methods on NSString
      let text = (self.text ?? "") as NSString
      
      // The x position of the prefix
      var prefixXPosition: CGFloat = 0
      
      // Spacing between prefix and text
      let spacing: CGFloat = 3.0
      
      // Font and color for the prefix
      let color = self.prefixTextColor ?? self.textColor ?? self.placeHolderTextColor
      let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): self.font!, NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): color]
      
      // Calc the x position of the prefix
      if textAlignment == .center {
        let fieldWidth = frame.size.width
        let textWidth = text.size(withAttributes: attrs).width
        prefixXPosition = (fieldWidth / 2) - (textWidth / 2)
      } else if textAlignment == .right {
        let fieldWidth = frame.size.width
        let textWidth = text.size(withAttributes: attrs).width
        prefixXPosition = fieldWidth - textWidth
      }
      
      prefixXPosition -= (self.prefix! as NSString).size(withAttributes: attrs).width
      prefixXPosition -= spacing
      
      // Calc the rect to draw the suffix in
      let height = text.size(withAttributes: attrs).height
      let verticalCenter = height / 2.0
      let top: CGFloat = frame.size.height / 2 - ceil(verticalCenter)
      let width = (self.prefix! as NSString).size(withAttributes: attrs).width
      let offset = (width + spacing) / 2
      let rect = CGRect(x: prefixXPosition + offset, y: top, width: width, height: height)
      
      
      // Draw it
      (self.prefix! as NSString).draw(in: rect, withAttributes: attrs)
      self.centerWithPrefix(offset: offset)
    } else {
      self.centerWithPrefix(offset: 0)
    }
    
    layer.masksToBounds = true
    borderStyle = .none
    layer.borderWidth = 1.0
    layer.borderColor = self.defaultBorderColor.cgColor
    
    self.placeholderColor(placeholderColor)
    
    addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
  }

  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: inset)
  }

  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: inset)
  }

  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: inset)
  }

  @objc open func textFieldDidBeginEditing() {
    layer.borderColor = self.defaultBorderColor.cgColor
  }

  @objc open func textFieldDidEndEditing() {
    layer.borderColor = self.defaultBorderColor.cgColor
  }

  @objc func textFieldDidChange(sender: AnyObject) {
    setNeedsDisplay()
  }
}
