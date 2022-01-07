//
//  NoteImageSection.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct NoteImageSection {
  enum Identity: Int, CaseIterable {
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

extension NoteImageSection: Equatable {
  static func == (lhs: NoteImageSection, rhs: NoteImageSection) -> Bool {
    return lhs.items == rhs.items
  }
}

enum NoteImageSectionItem: Hashable {
  case empty(EmptyNoteImageItemCellReactor)
  case item(NoteImageItemCellReactor)
}

extension NoteImageSectionItem: IdentifiableType {
  var identity: String {
    return "\(self.hashValue)"
  }
}
