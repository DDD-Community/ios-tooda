//
//  ColorRepository.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa


protocol ColorRepository {
	func colorList() -> Observable<String>
}

class DefaultColorRepository: ColorRepository {
	
	private let networking: NetworkingProtocol

	init(networking: NetworkingProtocol) {
		self.networking = networking
	}


	func colorList() -> Observable<String> {
		return self.networking.request(ColorAPI.colorList)
			.asObservable()
			.mapString()
			.flatMap { data -> Observable<String> in
				return Observable.just(data)
			}
	}
}
