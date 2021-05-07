//
//  ColorSection.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import RxDataSources

struct ColorSection {
	enum Identity: Int {
		case item
		
	}
	let identity: Identity
	var items: [ColorSectionItem]
}

extension ColorSection: AnimatableSectionModelType {
	init(original: ColorSection, items: [ColorSectionItem]) {
		self = .init(identity: original.identity, items: items)
	}
}

extension ColorSectionItem: IdentifiableType {
	var identity: String {
		return "\(self.hashValue)"
	}
}

enum ColorSectionItem: Hashable {
	case item(ColorItemCellReactor)
}
