//
//  EmojiOptionsSectionModel.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/29.
//

import RxDataSources

struct EmojiOptionsSectionModel {
  var identity = "emojiSection"
  var items: [Sticker]
}

extension EmojiOptionsSectionModel: SectionModelType {
  init(
    original: EmojiOptionsSectionModel,
    items: [Sticker]
  ) {
    self = .init(items: items)
  }
}
