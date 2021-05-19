//
//  DiarySection.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct DiarySection {
	enum Identity: Int {
		case content
		case stock
		case addStock
		case link
		case addLink
		case image
	}
	let identity: Identity
	var items: [DiarySectionItem]
}

extension DiarySection: SectionModelType {
	init(original: DiarySection, items: [DiarySectionItem]) {
		self = .init(identity: original.identity, items: items)
	}
}

enum DiarySectionItem {
	case content(DiaryContentCellReactor)
	case stock(DiaryStockCellReactor)
	case link(DiaryLinkCellReactor)
	case image(DiaryImageCellReactor)
}
