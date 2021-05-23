//
//  Note.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

// TODO:재봉님께 양식 전달 받은 이후에 값 변경
enum Comment: String, Codable {
	case smile, sad
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
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case comment = "comment"
		case noteStocks = "diary_stocks"
		case noteLinks = "diary_links"
		case noteImages = "diary_images"
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
