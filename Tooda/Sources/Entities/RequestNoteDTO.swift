//
//  RequestNoteDTO.swift
//  Tooda
//
//  Created by lyine on 2021/05/26.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import Moya

struct RequestNoteDTO {
  var title: String
  var content: String
  var links: [String]
  var stocks: [NoteStockDTO]
  var sticker: Comment
  var imageRawData: [Data]
}

extension RequestNoteDTO {
  
  init() {
    self.title = ""
    self.content = ""
    self.links = []
    self.stocks = []
    self.sticker = .omg
    self.imageRawData = []
  }
  
  func asParameters() -> [MultipartFormData] {
    var form: [MultipartFormData] = []
    
    let title = MultipartFormData(provider: .data(self.title.data(using: .utf8)!), name: "title", mimeType: "text/plain")
    let content = MultipartFormData(provider: .data(self.content.data(using: .utf8)!), name: "content", mimeType: "text/plain")
    
	
	if let linksData = try? JSONSerialization.data(withJSONObject: self.links, options: []) {
		let links = MultipartFormData(provider: .data(linksData), name: "links", mimeType: "text/plain")
		form.append(links)
	}
	
	let stockJsonString = self.stocks.compactMap({ $0.jsonString })
	
	if let stocksData = try? JSONSerialization.data(withJSONObject: stockJsonString, options: []) {
		let stocks = MultipartFormData(provider: .data(stocksData), name: "stocks", mimeType: "text/plain")
		form.append(stocks)
	}
    
    let sticker = MultipartFormData(provider: .data(self.sticker.rawValue.uppercased().data(using: .utf8)!), name: "sticker", mimeType: "text/plain")
    
    let images: [MultipartFormData] = self.imageRawData.enumerated().map { key, imageData -> MultipartFormData in
      return MultipartFormData(provider: .data(imageData), name: "files", fileName: "\(key).jpeg", mimeType: "image/jpeg")
    }
    
    form.append(title)
    form.append(content)
    
    for image in images.enumerated() {
      form.append(image.element)
    }
    
    form.append(sticker)
    
    return form
  }
}

struct NoteStockDTO {
  var name: String
  var change: StockChangeState?
  var changeRate: Float?
}

extension NoteStockDTO {
  var jsonString: String? {
    var parameter: [String: Any] = [:]
    
    parameter.concat(dict: [
      "name": self.name
    ])
    
    if let changeRate = self.changeRate {
      parameter.concat(dict: [
        "changeRate": changeRate
      ])
    }
    
    if let change = self.change {
      parameter.concat(dict: [
		"change": change.rawValue.uppercased()
      ])
    }
    
	return parameter.jsonStringRepresentation
  }
}
