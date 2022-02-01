//
//  NoteDetailSection.swift
//  Tooda
//
//  Created by Lyine on 2022/01/19.
//

import RxDataSources

struct NoteDetailSection {
  enum Identity: Int {
    case header
    case stock
    case link
    case image
  }
  let identity: Identity
  var items: [NoteDetailSectionItem]
}

extension NoteDetailSection: SectionModelType {
  init(original: NoteDetailSection, items: [NoteDetailSectionItem]) {
    self = .init(identity: original.identity, items: items)
  }
}

enum NoteDetailSectionItem {
  case sticker(Sticker)
  case title(String, Date?)
  case content(String)
  case stock(NoteStockCellReactor)
  case image(Data)
  case link(NoteLinkCellReactor)
}
