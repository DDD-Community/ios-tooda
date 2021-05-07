//
//  ColorUseCase.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxSwift

protocol ColorUseCase: class {
	func colorList() -> Observable<String>
}

class DefaultColorUseCase: ColorUseCase {
	
	private let repository: ColorRepository
	
	init(repository: ColorRepository) {
		self.repository = repository
	}
	
	func colorList() -> Observable<String> {
		return self.repository.colorList()
	}
}
