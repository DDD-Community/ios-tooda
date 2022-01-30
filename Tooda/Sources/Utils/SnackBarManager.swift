//
//  SnackBarManager.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/30.
//

import Foundation
import UIKit

enum SnackBarType {
  case positive
  case negative
  
  var backgroundColor: UIColor {
    switch self {
    case .positive:
      return UIColor.mainGreen
    case .negative:
      return UIColor.gray3
    }
  }
  
  var emojiImage: UIImage? {
    switch self {
    case .positive:
      return UIImage(type: .iconPositiveEmoji)
    case .negative:
      return UIImage(type: .iconNegativeEmoji)
    }
  }
}

final class SnackBarManager {
  
  // MARK: - Constants
  
  enum Constants {
    static let movementDuration: Double = 0.1
    static let durationUnitPerChar: Double = 0.15
  }
  
  // MARK: - Properties
  
  static let shared = SnackBarManager()
  
  private var isDisplaying: Bool {
    guard let keyWindow = UIApplication.keyWindow else { return false }
    
    let snackBars = keyWindow.subviews.compactMap { $0 as? SnackBar }
    return !snackBars.isEmpty
  }
  
  // MARK: - Con(De)structor
  
  private init() { }
  
  // MARK: - Internal methods
  
  func display(type: SnackBarType, title: String) {
    guard let keyWindow = UIApplication.keyWindow,
          !isDisplaying else {
        return
    }
    
    let snackBar = setupSnackBar(
      keyWindow: keyWindow,
      type: type,
      title: title
    )
    
    let duration = calculateDuration(title: title)
    let movementRatio: Double = Constants.movementDuration / duration
    
    UIView.animateKeyframes(
      withDuration: duration,
      delay: 0
    ) {
      snackBar.snp.updateConstraints {
        $0.bottom.equalToSuperview().offset(-40)
      }
      
      UIView.addKeyframe(
        withRelativeStartTime: 0,
        relativeDuration: movementRatio) {
        keyWindow.layoutIfNeeded()
      }
      
      snackBar.snp.updateConstraints {
        $0.bottom.equalToSuperview().offset(60)
      }
      
      UIView.addKeyframe(
        withRelativeStartTime: 1 - movementRatio,
        relativeDuration: 1) {
        
        keyWindow.layoutIfNeeded()
      }
    } completion: { isCompleted in
      if isCompleted {
        snackBar.removeFromSuperview()
      }
    }
  }
  
  // MARK: - Private methods
  
  private func calculateDuration(title: String) -> Double {
    let trimmedString = title.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return Double(trimmedString.count) * Constants.durationUnitPerChar
  }
  
  private func setupSnackBar(
    keyWindow: UIWindow,
    type: SnackBarType,
    title: String
  ) -> SnackBar {
    let snackBar = SnackBar(type: type).then {
      $0.setTitle(with: title)
    }
    
    keyWindow.addSubview(snackBar)
    
    snackBar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().offset(60)
    }
    
    keyWindow.layoutIfNeeded()
    
    return snackBar
  }
}
