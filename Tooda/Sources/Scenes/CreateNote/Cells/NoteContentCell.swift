//
//  NoteContentCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import SnapKit
import Then

class NoteContentCell: BaseTableViewCell, View {
	typealias Reactor = NoteContentCellReactor
	
	var disposeBag: DisposeBag = DisposeBag()
	
	let titleTextField = CustomTextField(frame: .zero).then {
		$0.font = UIFont.systemFont(ofSize: 13, weight: .bold)
		$0.textColor = ToodaAsset.Colors.gray1.color
		$0.placeholder = "제목을 입력해 주세요"
		$0.placeholderColor = ToodaAsset.Colors.gray4.color
	}
	
	let contentTextFieldBackgroundView = UIView().then {
		$0.clipsToBounds = true
		$0.layer.cornerRadius = 8.0
		$0.layer.borderColor = ToodaAsset.Colors.gray4.color.cgColor
		$0.layer.borderWidth = 1.0
	}
	
	let contentTextField = UITextField().then {
		$0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
		$0.textColor = ToodaAsset.Colors.gray1.color
		$0.placeholder = "제목을 입력해 주세요"
	}
	
	func configure(reactor: Reactor) {
		super.configure()
		self.reactor = reactor
	}
	
	override func configureUI() {
		super.configureUI()
		
		[titleTextField, contentTextFieldBackgroundView].forEach {
			self.contentView.addSubview($0)
		}
		
		[contentTextField].forEach {
			self.contentTextFieldBackgroundView.addSubview($0)
		}
	}
	
	override func setupConstraints() {
		super.setupConstraints()
		
		titleTextField.snp.makeConstraints {
			$0.top.left.right.width.equalToSuperview()
			$0.height.equalTo(43)
		}
		
		contentTextFieldBackgroundView.snp.makeConstraints {
			$0.top.equalTo(titleTextField.snp.bottom).offset(10)
			$0.left.right.bottom.width.equalToSuperview()
			$0.height.equalTo(169)
		}
		
		contentTextField.snp.makeConstraints {
			$0.top.equalToSuperview().offset(16)
			$0.left.equalToSuperview().offset(14)
			$0.right.equalToSuperview().offset(-14)
			$0.bottom.equalToSuperview().offset(-16)
		}
	}
	
	func bind(reactor: Reactor) {
		
	}
}
