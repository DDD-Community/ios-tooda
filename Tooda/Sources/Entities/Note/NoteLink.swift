//
//  NoteLink.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

struct NoteLink: Codable {
	var id: Int
	var title: String
	var description: String?
	var siteName: String?
	var url: String
	var imageURL: String?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case description = "description"
		case siteName = "site_name"
		case url = "url"
		case imageURL = "image"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		title = try values.decode(String.self, forKey: .title)
		description = try values.decode(String.self, forKey: .description)
		siteName = try values.decode(String.self, forKey: .siteName)
		url = try values.decode(String.self, forKey: .url)
		imageURL = try values.decode(String.self, forKey: .imageURL)
	}
}
