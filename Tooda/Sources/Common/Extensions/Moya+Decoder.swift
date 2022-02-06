//
//  Moya+Decoder.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/02/01.
//

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

  func toodaMap<D: Decodable>(_ type: D.Type) -> Single<D> {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    return self.map(
      type,
      atKeyPath: nil,
      using: decoder,
      failsOnEmptyData: true
    )
  }
}
