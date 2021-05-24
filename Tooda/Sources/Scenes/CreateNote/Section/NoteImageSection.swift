//
//  NoteImageSection.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct NoteImageSection {
  enum Identity: Int {
    case empty
    case item
  }
  let identity: Identity
  var items: [NoteImageSectionItem]
}

extension NoteImageSection: SectionModelType {
  init(original: NoteImageSection, items: [NoteImageSectionItem]) {
    self = .init(identity: original.identity, items: items)
  }
}

enum NoteImageSectionItem {
  case empty(EmptyNoteImageItemCellReactor)
  case item(NoteImageItemCellReactor)
}
