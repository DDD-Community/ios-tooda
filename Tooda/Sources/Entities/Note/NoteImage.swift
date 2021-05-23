//
//  NoteImage.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

struct NoteImage: Codable {
	var id: Int
	var imageURL: String
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case imageURL = "image"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		imageURL = try values.decode(String.self, forKey: .imageURL)
	}
}
