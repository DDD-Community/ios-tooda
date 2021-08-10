//
//  Note.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

enum Comment: String, Codable {
	case SAD, OMG, ANGRY, THINKING, CHICKEN, PENCIL
}

struct Note: Codable {
	var id: Int
	var title: String
	var content: String
	var createdAt: String
	var updatedAt: String
	var comment: Comment
	var noteStocks: [NoteStock]
	var noteLinks: [NoteLink]
	var noteImages: [NoteImage]
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case content = "content"
		case comment = "sticker"
		case noteStocks = "stocks"
		case noteLinks = "links"
		case noteImages = "images"
		case createdAt = "createdAt"
		case updatedAt = "updatedAt"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		title = try values.decode(String.self, forKey: .title)
		content = try values.decode(String.self, forKey: .content)
		createdAt = try values.decode(String.self, forKey: .createdAt)
		updatedAt = try values.decode(String.self, forKey: .updatedAt)
		comment = try values.decode(Comment.self, forKey: .comment)
		noteStocks = try values.decode([NoteStock].self, forKey: .noteStocks)
		noteLinks = try values.decode([NoteLink].self, forKey: .noteLinks)
		noteImages = try values.decode([NoteImage].self, forKey: .noteImages)
	}
}
