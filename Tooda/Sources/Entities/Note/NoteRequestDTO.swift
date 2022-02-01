//
//  NoteRequestDTO.swift
//  Tooda
//
//  Created by Lyine on 2022/01/08.
//

import Foundation

struct NoteRequestDTO {
  var id: String?
  var updatedAt: Date?
  var createdAt: Date?
  var title: String
  var content: String
  var stocks: [NoteStock]
  var links: [String]
  var images: [String]
  var sticker: Sticker
}

extension NoteRequestDTO {
  
  init() {
    id = nil
    title = ""
    content = ""
    stocks = []
    links = []
    images = []
    sticker = .wow
  }
  
  func asBodyParameters() -> [String: Any] {
    var parameters: [String: Any] = [:]
    
    if let id = id {
      parameters.concat(dict: [
        "id": id
      ])
    }
    
    parameters.concat(dict: [
      "title": title,
      "content": content,
      "sticker": sticker.rawValue
    ])
    
    if stocks.isNotEmpty {
      parameters.concat(dict: [
        "stocks": stocks.map { $0.asParameter() }
      ])
    }
    
    if links.isNotEmpty {
      parameters.concat(dict: [
        "links": links
      ])
    }
    
    if images.isNotEmpty {
      parameters.concat(dict: [
        "images": images
      ])
    }
    
    return parameters
  }
}
