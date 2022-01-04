//
//  DiarySection.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct NoteSection {
  enum Identity: Int {
    case content
    case stock
    case addStock
    case link
    case image
  }
  let identity: Identity
  var items: [NoteSectionItem]
}

extension NoteSection: SectionModelType {
  init(original: NoteSection, items: [NoteSectionItem]) {
    self = .init(identity: original.identity, items: items)
  }
}

enum NoteSectionItem {
  case content(NoteContentCellReactor)
  case addStock(EmptyNoteStockCellReactor)
  case stock(NoteStockCellReactor)
  case image(NoteImageCellReactor)
  case link(NoteLinkCellReactor)
}
