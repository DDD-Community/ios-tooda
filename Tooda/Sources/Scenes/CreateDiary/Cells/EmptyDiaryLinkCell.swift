//
//  EmptyDiaryLinkCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit

class EmptyDiaryLinkCell: BaseTableViewCell, View {
	typealias Reactor = EmptyDiaryLinkCellReactor
	
	var disposeBag: DisposeBag = DisposeBag()
	
	func bind(reactor: Reactor) {
		
	}
}
