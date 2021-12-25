//
//  MockNetworking.swift
//  ToodaTests
//
//  Created by 황재욱 on 2021/12/26.
//

import Foundation
import Moya
import RxSwift
@testable import Tooda

final class MockNetworking: NetworkingProtocol {
  
  let statusCode: Int
  let mockProvider: ((TargetType) -> Data)?
  
  init(
    statusCode: Int = 200,
    mockProvider: ((TargetType) -> Data)? = nil
  ) {
    self.statusCode = statusCode
    self.mockProvider = mockProvider
  }
  
  func request(
    _ target: TargetType,
    file: StaticString,
    function: StaticString,
    line: UInt
  ) -> Single<Response> {
    guard let data = mockProvider?(target) else { return Single<Response>.never() }
    return Single<Response>.just(Response(statusCode: statusCode, data: data))
  }
}
