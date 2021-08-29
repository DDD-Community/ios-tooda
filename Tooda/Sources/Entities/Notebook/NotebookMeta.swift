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
  var createdAt: Date
  var updatedAt: Date
  var stickers: [Sticker] = []

  private enum CodingKeys: String, CodingKey {
    case year
    case month
    case noteCount = "totalCount"
    case createdAt
    case updatedAt
    case stickers
  }
}
