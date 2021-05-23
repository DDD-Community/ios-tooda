//
//  EmptyNoteStockCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit

class EmptyNoteStockCell: BaseTableViewCell, View {
	typealias Reactor = EmptyDiaryStockCellReactor
	
	var disposeBag: DisposeBag = DisposeBag()
	
	func bind(reactor: Reactor) {
		
	}
}
