//
//  HomeViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import Then

final class HomeViewController: BaseViewController<HomeReactor> {
    
    init(reactor: HomeReactor) {
        defer {
            self.reactor = reactor
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "홈"
        self.view.backgroundColor = .white
    }
    
    override func bind(reactor: HomeReactor) {
    }
    
}
