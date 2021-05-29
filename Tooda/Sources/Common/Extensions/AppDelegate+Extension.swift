//
//  AppDelegate+Extension.swift
//  Tooda
//
//  Created by lyine on 2021/05/27.
//  Copyright © 2021 DTS. All rights reserved.
//

#if DEBUG
import netfox
#endif

extension AppDelegate {
	func configureTools() {
		#if DEBUG
		NFX.sharedInstance().start()
		#endif
	}
}
