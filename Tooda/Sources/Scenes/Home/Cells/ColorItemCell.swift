//
//  ColorItemCell.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import ReactorKit
import SnapKit
import Then

class ColorCell: BaseTableViewCell, View {
	var disposeBag: DisposeBag = DisposeBag()
		
	typealias Reactor = ColorItemCellReactor
	
	let previewColor = UIView().then {
		$0.layer.cornerRadius = 12
	}
	
	let titleLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16)
		$0.textColor = ColorLists.label
		$0.sizeToFit()
	}
	
	let hexCodeLabel = UILabel().then {
		$0.font = .systemFont(ofSize: 16)
		$0.textColor = ColorLists.label
	}
	
	func configure(reactor: Reactor) {
		super.configure()
		self.reactor = reactor
	}
	
	override func configureUI() {
		super.configureUI()
		
		[previewColor, titleLabel, hexCodeLabel].forEach {
			self.contentView.addSubview($0)
		}
	}
	
	override func setupConstraints() {
		super.setupConstraints()
		
		previewColor.snp.makeConstraints {
			$0.width.equalTo(previewColor.snp.height)
			$0.left.equalTo(contentView.layoutMarginsGuide.snp.left)
			$0.top.equalTo(contentView.layoutMarginsGuide.snp.top).offset(4)
			$0.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom).offset(-4)
			$0.height.equalTo(64).priority(.high)
		}
		
		titleLabel.snp.makeConstraints {
			$0.top.equalTo(previewColor.snp.top)
			$0.leading.equalTo(previewColor.snp.trailing).offset(12)
		}
		
		hexCodeLabel.snp.makeConstraints {
			$0.bottom.equalTo(previewColor.snp.bottom)
			$0.leading.equalTo(previewColor.snp.trailing).offset(12)
		}
	}
	
	func bind(reactor: ColorItemCellReactor) {
		self.reactor?.state
			.map { $0.color }
			.subscribe(onNext: { [weak self] in
				self?.fetchColor($0)
			}).disposed(by: self.disposeBag)
	}
	
	
	private func fetchColor(_ color: Color) {
		self.previewColor.backgroundColor = UIColor.init(hex: color.hex)
		self.titleLabel.text = color.name
		self.hexCodeLabel.text = color.hex
	}
}
