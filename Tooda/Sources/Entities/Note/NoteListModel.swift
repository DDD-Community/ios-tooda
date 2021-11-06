//
//  NoteListModel.swift
//  Tooda
//
//  Created by 황재욱 on 2021/10/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct NoteListModel {
  let identity: String
  var items: [Note]
}

extension NoteListModel: SectionModelType {
  init(
    original: NoteListModel,
    items: [Note]
  ) {
    self = .init(
      identity: "NoteListSection",
      items: items
    )
  }
}
