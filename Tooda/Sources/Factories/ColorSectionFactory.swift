//
//  ColorSectionFactory.swift
//  Tooda
//
//  Created by lyine on 2021/04/09.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation

let colorFactory: ([Color]) -> [ColorSection] = { colors -> [ColorSection] in
	
	var sections: [ColorSection] =  [ColorSection.init(identity: .item, items: [])]
	
	let sectionItems = colors
		.map { ColorItemCellReactor(color: $0) }
		.map { ColorSectionItem.item($0) }
	
	sections[ColorSection.Identity.item.rawValue].items = sectionItems
	
	return sections
}
