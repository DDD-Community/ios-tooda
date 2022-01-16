//
//  Note.swift
//  Tooda
//
//  Created by lyine on 2021/05/18.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

import RxDataSources

struct Note: Codable, IdentifiableType, Equatable {
  static func == (lhs: Note, rhs: Note) -> Bool {
    return lhs.id == rhs.id
  }
  
  var identity: Int {
    return id
  }
  var id: Int
  var title: String
  var content: String
  var createdAt: String?
  var updatedAt: String?
  var sticker: Sticker?
  var noteStocks: [NoteStock]
  var noteLinks: [NoteLink]?
  var noteImages: [NoteImage]
  
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case title = "title"
    case content = "content"
    case sticker = "sticker"
    case noteStocks = "stocks"
    case noteLinks = "links"
    case noteImages = "images"
    case createdAt = "createdAt"
    case updatedAt = "updatedAt"
  }
}
