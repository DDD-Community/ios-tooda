//
//  TextStyle.swift
//  Tooda
//
//  Created by jinsu on 2021/05/23.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit


extension String {
  typealias Style = [NSAttributedString.Key: Any]

  func styled(with style: Style) -> NSAttributedString {
    return NSAttributedString(
      string: self,
      attributes: style
    )
  }

  func underline(
    _ style: NSUnderlineStyle,
    color: UIColor? = nil,
    with textStyle: Style
  ) -> NSAttributedString {
    var mutableTextStyle = textStyle
    mutableTextStyle.updateValue(style.rawValue, forKey: .underlineStyle)
    if let color = color {
      mutableTextStyle.updateValue(color, forKey: .underlineColor)
    }

    return NSAttributedString(
      string: self,
      attributes: mutableTextStyle
    )
  }
}

enum TextStyle {
  static func headline(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 39.2
    let font = UIFont.systemFont(ofSize: 28.0, weight: .regular)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func headlineBold(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 39.2
    let font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func title(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 33.6
    let font = UIFont.systemFont(ofSize: 24.0, weight: .regular)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func titleBold(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 33.6
    let font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func subTitle(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 25.2
    let font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func subTitleBold(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 25.2
    let font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func body2(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 24.0
    let font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func body2Bold(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 24.0
    let font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func body(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 20.8
    let font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func bodyBold(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 20.8
    let font = UIFont.systemFont(ofSize: 13.0, weight: .bold)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func caption(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 17.6
    let font = UIFont.systemFont(ofSize: 11.0, weight: .regular)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }

  static func captionBold(color: UIColor) -> [NSAttributedString.Key: Any] {
    let lineHeight: CGFloat = 17.6
    let font = UIFont.systemFont(ofSize: 11.0, weight: .bold)
    let style = NSMutableParagraphStyle()

    style.maximumLineHeight = lineHeight
    style.minimumLineHeight = lineHeight

    let attributes: [NSAttributedString.Key: Any] = [
      .paragraphStyle: style,
      .baselineOffset: (lineHeight - font.lineHeight) / 2,
      .font: font,
      .foregroundColor: color
    ]

    return attributes
  }
  
}
