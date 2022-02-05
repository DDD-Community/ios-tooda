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
  var width: Int?
  var height: Int?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case imageURL = "image"
    case width, height
	}
}
