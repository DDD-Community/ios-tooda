//
//  NetwokringProtocol.swift
//  Tooda
//
//  Created by lyine on 2021/04/08.
//  Copyright © 2021 DTS. All rights reserved.
//

import SystemConfiguration
import Moya
import RxSwift
import RxCocoa

protocol NetworkingProtocol {
  func request(_ target: TargetType, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension NetworkingProtocol {
  func request(_ target: TargetType, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
    return self.request(target, file: file, function: function, line: line)
  }
}

final class Networking: MoyaProvider<MultiTarget>, NetworkingProtocol {

  var disposeBag: DisposeBag = DisposeBag()

  let intercepter: ConnectChecker

  init(plugins: [PluginType]) {
    let intercepter = ConnectChecker()
    self.intercepter = intercepter

    let session = MoyaProvider<MultiTarget>.defaultAlamofireSession()
    session.sessionConfiguration.timeoutIntervalForRequest = 10
    super.init(requestClosure: { endpoint, completion in
      do {
        var urlRequest = try endpoint.urlRequest()
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        intercepter.adapt(urlRequest, for: session, completion: completion)
      } catch MoyaError.requestMapping(let url) {
        completion(.failure(MoyaError.requestMapping(url)))
      } catch MoyaError.parameterEncoding(let error) {
        completion(.failure(MoyaError.parameterEncoding(error)))
      } catch {
        completion(.failure(MoyaError.underlying(error, nil)))
      }
    }, session: session, plugins: plugins)
  }

  func request(_ target: TargetType, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) -> Single<Response> {
    let requestString = "\(target.method.rawValue) \(target.path)"

    return self.rx.request(.target(target))
      .filterSuccessfulStatusCodes()
      .do(
      onSuccess: { value in
        let message = "SUCCESS: \(requestString) (\(value.statusCode))"
        log.debug(message, file: file, function: function, line: line)
      },
      onError: { error in
        if let response = (error as? MoyaError)?.response {
          if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
            log.warning(message, file: file, function: function, line: line)
          } else if let rawString = String(data: response.data, encoding: .utf8) {
            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
            log.warning(message, file: file, function: function, line: line)
          } else {
            let message = "FAILURE: \(requestString) (\(response.statusCode))"
            log.warning(message, file: file, function: function, line: line)
          }
        } else {
          let message = "FAILURE: \(requestString)\n\(error)"
          log.debug(message, file: file, function: function, line: line)
        }
      },
      onSubscribed: {
        let message = "REQUEST: \(requestString)"
        log.debug(message)
      }
    )
      .catchError {
      guard let error = $0 as? MoyaError else {
        return .error(BaseApiError.message($0.localizedDescription))
      }

      if case let .statusCode(status) = error {
        if let badRequestResponse = JSONDecoder.decodeOptional(status.data, type: Conversion.self) {
          let errorMessage = BaseApiError.message(badRequestResponse.message)
          return .error(errorMessage)
        }
      }
      return .error(BaseApiError.message("알 수 없는 에러 발생"))
    }
  }
}

internal class ConnectChecker {
  init() { }

  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, MoyaError>) -> Void) {

    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)

    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      completion(.success(urlRequest))
      return
    }

    var flags: SCNetworkReachabilityFlags = []

    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {

      // Todo: Show Alert

//			DispatchQueue.main.async {
//				UIWindow(frame: UIScreen.main.bounds).switchRootViewController(rootViewController: CommonNavigator.networkingConnection(true).viewController, animated: true, completion: nil)
//			}

      completion(.failure(MoyaError.underlying(BaseApiError.message("알 수 없는 에러 발생"), nil)))
      return
    }

    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)

    if isReachable && !needsConnection {
      completion(.success(urlRequest))
    } else {

      // Todo: Show Alert

//			DispatchQueue.main.async {
//				UIWindow(frame: UIScreen.main.bounds).switchRootViewController(rootViewController: CommonNavigator.networkingConnection(true).viewController, animated: true, completion: nil)
//			}

      completion(.failure(MoyaError.underlying(BaseApiError.message("알 수 없는 에러 발생"), nil)))
      return
    }
  }
}
