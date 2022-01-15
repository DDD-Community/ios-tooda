//
//  NoteListDTO.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/14.
//

import Foundation

struct NoteListDTO: Codable {
  let cursor: Int?
  let noteList: [Note]?
  
  enum CodingKeys: String, CodingKey {
    case cursor = "cursor"
    case noteList = "notes"
  }
}
