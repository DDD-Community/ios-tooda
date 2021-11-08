//
//  AddStockSectionFactory.swift
//  Tooda
//
//  Created by Lyine on 2021/11/06.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

protocol AddStockSectionFactoryType {
  var searchResult: ([Stock]) -> [AddStockSection] { get }
}

struct AddStockSectionFactory: AddStockSectionFactoryType {
  let searchResult: ([Stock]) -> [AddStockSection] = { stocks -> [AddStockSection] in
    let sectionItems = stocks
      .map { StockItemCellReactor.Dependency(id: $0.id, name: $0.name) }
      .map { StockItemCellReactor(dependency: $0) }
      .map { AddStockSectionItem.item($0) }
    
    return [AddStockSection(identity: .list, items: sectionItems)]
  }
}
