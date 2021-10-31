//
//  AddStockSection.swift
//  Tooda
//
//  Created by Lyine on 2021/10/31.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct AddStockSection {
  enum Identity: Int {
    case list
  }
  let identity: Identity
  var items: [AddStockSectionItem]
}

extension AddStockSection: SectionModelType {
  init(original: AddStockSection, items: [AddStockSectionItem]) {
    self = .init(identity: original.identity, items: items)
  }
}

enum AddStockSectionItem {
  case item(StockItemCellReactor)
}
