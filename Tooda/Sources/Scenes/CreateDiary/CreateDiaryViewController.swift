//
//  CreateDiaryViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit

class CreateDiaryViewController: UIViewController, View {
	typealias Reactor = CreateDiaryViewReactor
	
	var disposeBag: DisposeBag = DisposeBag()
	
	init(reactor: Reactor) {
		
		defer {
			self.reactor = reactor
		}
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required convenience init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		configureNavigation()
		configureUI()
		setupConstraints()
	}
	
	func bind(reactor: Reactor) {
		
		// Action
		self.rx.viewDidLoad
			.map { _ in Reactor.Action.initializeForm }
			.bind(to: reactor.action)
			.disposed(by: self.disposeBag)
	}
}

// MARK: ViewController Configuration

extension CreateDiaryViewController: ViewControllerConfiguration {
	func configureNavigation() {
		//		self.navigationItem.title = ""
	}
	
	func configureUI() {
		self.view.backgroundColor = .white
	}
	
	func setupConstraints() {
	}
}
