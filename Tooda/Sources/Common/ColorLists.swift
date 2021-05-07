//
//  ColorLists.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

enum ColorLists {
	static var background: UIColor {
		if #available(iOS 13.0, *) {
			return .systemBackground
		} else {
			return .white
		}
	}
	
	static var label: UIColor {
		if #available(iOS 13.0, *) {
			return .label
		} else {
			return .black
		}
	}
	
	static var gray5: UIColor {
		if #available(iOS 13.0, *) {
			return .systemGray5
		} else {
			return UIColor(displayP3Red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)
		}
	}
}
