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
    let dateFormatter = DateFormatter().then {
      $0.dateFormat = Date.DateFormatType.server.rawValue
      $0.locale = Locale.current
      $0.timeZone = TimeZone.current
    }
    decoder.dateDecodingStrategy = .formatted(dateFormatter)

    return self.map(
      type,
      atKeyPath: nil,
      using: decoder,
      failsOnEmptyData: true
    )
  }
}
