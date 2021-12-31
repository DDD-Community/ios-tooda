//
//  SearchRecentSectionModel.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct SearchRecentSectionModel {

  let identity: SectionType
  var items: [SectionItem]
}

extension SearchRecentSectionModel: SectionModelType {

  init(original: SearchRecentSectionModel, items: [SectionItem]) {
    self = .init(identity: original.identity, items: items)
  }

  enum SectionType: Int {
    case header
    case keyword

    var cellHeight: CGFloat {
      switch self {
      case .header:
        return 21.0

      case .keyword:
        return 24.0
      }
    }

    var edgeInsets: UIEdgeInsets {
      switch self {
      case .header:
        return .init(top: 32.0, left: 20.0, bottom: 16.0, right: 20.0)

      case .keyword:
        return .init(horizontal: 20.0)
      }
    }
  }

  enum SectionItem {
    case header
    case keyword(SearchRecentKeywordCell.ViewModel)
  }
}
