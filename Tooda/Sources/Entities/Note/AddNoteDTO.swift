//
//  AddNoteDTO.swift
//  Tooda
//
//  Created by Lyine on 2022/01/08.
//

import Foundation

struct AddNoteDTO {
  var title: String
  var content: String
  var stocks: [NoteStock]?
  var links: [String]?
  var images: [String]?
  var sticker: Sticker
}

extension AddNoteDTO {
  func asBodyParameters() -> [String: Any] {
    var parameters: [String: Any] = [:]
    
    parameters.concat(dict: [
      "title": title,
      "content": content,
      "sticker": sticker
    ])
    
    if let stocks = stocks {
      parameters.concat(dict: [
        "stocks": stocks
      ])
    }
    
    if let links = links {
      parameters.concat(dict: [
        "links": links
      ])
    }
    
    if let images = images {
      parameters.concat(dict: [
        "images": images
      ])
    }
    
    return parameters
  }
}
