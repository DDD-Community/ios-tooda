//
//  OneLineReviewPopUpViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class OneLineReviewPopUpViewController: BaseViewController<OneLineReviewPopUpReactor> {
  
  // MARK: - UI Components
  
  private let dimmedView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.4)
  }
  
  private let popUpView = OptionsPopUpView()
  
  // MARK: - Con(De)structor
  
  init(reactor: OneLineReviewPopUpReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
}

// MARK: - SetupUI
extension OneLineReviewPopUpViewController {
  private func setupUI() {
    
    view.do {
      $0.backgroundColor = .clear
      $0.addSubview(dimmedView)
    }
    
    dimmedView.addSubview(popUpView)
    
    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    popUpView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
