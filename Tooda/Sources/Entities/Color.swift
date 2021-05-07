//
//  Color.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

struct Color: Codable {
	var name: String
	var hex: String
	var isFavorite: Bool
}

extension Color: Hashable {
	static func == (lhs: Color, rhs: Color) -> Bool {
		// TODO... 상태 변화가 어디 까지 필요 한가??
		return lhs.hex == rhs.hex && lhs.name == rhs.name && lhs.isFavorite == rhs.isFavorite
	}
}
