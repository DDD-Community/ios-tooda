//
//  Diary.swift
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

struct Diary: Codable {
	var id: Int
	var title: String
	var content: String
	var createdAt: String
	var updatedAt: String
	var comment: Comment
	var diaryStocks: [DiaryStock]
	var diaryLinks: [DiaryLink]
	var diaryImages: [DiaryImage]
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "title"
		case content = "content"
		case createdAt = "created_at"
		case updatedAt = "updated_at"
		case comment = "comment"
		case diaryStocks = "diary_stocks"
		case diaryLinks = "diary_links"
		case diaryImages = "diary_images"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		title = try values.decode(String.self, forKey: .title)
		content = try values.decode(String.self, forKey: .content)
		createdAt = try values.decode(String.self, forKey: .createdAt)
		updatedAt = try values.decode(String.self, forKey: .updatedAt)
		comment = try values.decode(Comment.self, forKey: .comment)
		diaryStocks = try values.decode([DiaryStock].self, forKey: .diaryStocks)
		diaryLinks = try values.decode([DiaryLink].self, forKey: .diaryLinks)
		diaryImages = try values.decode([DiaryImage].self, forKey: .diaryImages)
	}
}
