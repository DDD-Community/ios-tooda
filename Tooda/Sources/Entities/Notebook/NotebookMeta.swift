//
//  NotebookMeta.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/07/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

struct NotebookMeta: Codable {

  var year: Int
  var month: Int
  var noteCount: Int
  var createdAt: Date?
  var updatedAt: Date?
  var stickers: [Sticker] = []

  init(
    year: Int,
    month: Int,
    noteCount: Int = 0,
    createdAt: Date? = nil,
    updatedAt: Date? = nil,
    stickers: [Sticker] = []
  ) {
    self.year = year
    self.month = month
    self.noteCount = noteCount
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.stickers = stickers
  }

  private enum CodingKeys: String, CodingKey {
    case year
    case month
    case noteCount = "totalCount"
    case createdAt
    case updatedAt
    case stickers
  }
}
