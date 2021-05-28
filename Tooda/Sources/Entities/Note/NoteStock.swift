//
//  NoteStock.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

enum StockChangeState: String, Codable {
	case RISE
	case EVEN
	case FALL
}

struct NoteStock: Codable {
	var id: Int
	var name: String
	var change: StockChangeState?
	var changeRate: Float?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case change = "change"
		case changeRate = "changeRate"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		name = try values.decode(String.self, forKey: .name)
		change = try values.decode(StockChangeState.self, forKey: .change)
		changeRate = try values.decode(Float.self, forKey: .changeRate)
	}
}
