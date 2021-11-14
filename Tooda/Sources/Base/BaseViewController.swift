//
//  BaseViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import UIKit

import ReactorKit
import RxSwift

class BaseViewController<T: Reactor>: UIViewController, View {
  typealias Reactor = T
  
  var disposeBag: DisposeBag = DisposeBag()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    configureConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: T) {}
  
  func configureUI() {}
  func configureConstraints() {}

  @discardableResult
  func configureBackBarButtonItemIfNeeded() -> Observable<Void> {
    Observable<Void>.create({ observer in
      if self.navigationController?.viewControllers.count ?? 0 >= 2 {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
          image: UIImage(type: .backBarButton),
          style: .plain,
          action: {
            observer.onNext(())
          }
        )
      }
      return Disposables.create()
    })
  }
}
