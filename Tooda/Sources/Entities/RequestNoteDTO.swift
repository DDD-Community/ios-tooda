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
}

extension RequestNoteDTO {
  
  init() {
    self.title = ""
    self.content = ""
    self.links = []
    self.stocks = []
    self.sticker = .OMG
  }
  
	func asParameters() -> [String: Any] {
		var parameter: [String: Any] = [:]
		
		parameter.concat(dict: [
			"title": title,
			"sticker": sticker.rawValue.uppercased()
		])
		
		if !content.isEmpty {
			parameter.concat(dict: [
				"content": content
			])
		}
		
		if !links.isEmpty {
			parameter.concat(dict: [
				"links": links
			])
		}
		
		if !stocks.isEmpty {
			parameter.concat(dict: [
				"stocks": stocks.map { $0.dictionary } 
			])
		}
		
		return parameter
	}
}

struct NoteStockDTO {
  var name: String
  var change: StockChangeState?
  var changeRate: Float?
	
	init(name: String, change: StockChangeState?, changeRate: Float?) {
		self.name = name
		self.change = change
		self.changeRate = changeRate
	}
}

extension NoteStockDTO {
  var dictionary: [String: Any] {
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
    
	return parameter
  }
}
