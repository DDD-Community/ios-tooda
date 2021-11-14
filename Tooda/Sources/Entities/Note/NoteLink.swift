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
	var url: String?
	var imageURL: String?
	var createdAt: String?
	
	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case title = "ogTitle"
		case description = "ogDescription"
		case siteName = "ogSiteName"
		case url = "ogUrl"
		case imageURL = "ogImage"
		case createdAt = "createdAt"
	}
}
