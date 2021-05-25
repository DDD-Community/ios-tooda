//
//  AlertService.swift
//  Tooda
//
//  Created by lyine on 2021/05/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxSwift
import RxCocoa

protocol AlertServiceType: AnyObject {
  func show<Action: AlertActionType>(
    title: String?,
    message: String?,
    preferredStyle: UIAlertController.Style,
    actions: [Action]
  ) -> Observable<Action>
}

protocol AlertActionType {
  var title: String? { get }
  var style: UIAlertAction.Style { get }
}

extension AlertActionType {
  var style: UIAlertAction.Style {
    return .default
  }
}

final class AlertService: AlertServiceType {
  
  static let shared: AlertService = AlertService()
  
  private init() { }
  
  func show<Action>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action> where Action: AlertActionType {
    return Observable.create { observer -> Disposable in
      guard let message = message, !message.isEmpty else { return
        Disposables.create()
      }
      let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
      
      let messageAttributedString = NSAttributedString(string: message, attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular),
        NSAttributedString.Key.foregroundColor: UIColor(r: 44, g: 55, b: 68)
      ])
      
      let titleAttributedString = NSAttributedString(string: title ?? "", attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
        NSAttributedString.Key.foregroundColor: UIColor(r: 44, g: 55, b: 68)
      ])
      
      
      for action in actions {
        let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
          observer.onNext(action)
          observer.onCompleted()
        }
        
        alert.addAction(alertAction)
      }
      
      alert.setValue(titleAttributedString, forKey: "attributedTitle")
      alert.setValue(messageAttributedString, forKey: "attributedMessage")
      
      if let topView = UIApplication.topViewController() {
        DispatchQueue.main.async {
          topView.present(alert, animated: true, completion: nil)
        }
      }
      
      
      return Disposables.create {
        alert.dismiss(animated: true, completion: nil)
      }
    }
  }
}
