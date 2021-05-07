//
//  HomeNavigator.swift
//  Toda
//
//  Created by lyine on 2021/04/07.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

enum HomeNavigator {
	case main
}

extension HomeNavigator {
	var viewController: UIViewController {
		switch self {
			case .main:
				guard let service = AppInject.rootContainer.resolve(ColorUseCase.self) else { return UIViewController() }
				let reactor: HomeViewReactor = HomeViewReactor(service: service, factory: colorFactory)
				let viewController: HomeViewController = HomeViewController(reactor: reactor)
				return viewController
		}
	}
}
