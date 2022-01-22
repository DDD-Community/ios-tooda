//
//  SocialLoginService.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/22.
//

import Foundation

import RxSwift
import RxCocoa

enum SocialLoginType {
  case apple
}

final class SocialLoginService {
  
  enum SocialLoginError: Error {
    case parsingError
  }
  
  typealias SocialLoginResult = (token: String?, type: SocialLoginType, error: Error?)
  
  private let tokenProvider = PublishRelay<SocialLoginResult>
  
  init(tokenProvider: PublishRelay<SocialLoginResult>) {
    self.tokenProvider = tokenProvider
  }
}
