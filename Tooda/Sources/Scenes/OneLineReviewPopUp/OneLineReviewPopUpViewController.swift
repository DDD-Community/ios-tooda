//
//  OneLineReviewPopUpViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class OneLineReviewPopUpViewController: UIViewController {
  
  // MARK: - UI Components
  
  private let dimmedView = UIView()
  
  private let popUpView = UIView()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
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
  }
}
