//
//  SocialLoginService.swift
//  Tooda
//
//  Created by 황재욱 on 2022/01/22.
//

import Foundation

import AuthenticationServices
import RxSwift
import RxCocoa
import Moya

protocol SocialLoginServiceType {
  var tokenProvider: PublishSubject<SocialLoginService.SocialLoginResult> { get }
  func signIn(type: SocialLoginType)
}

enum SocialLoginType {
  case apple
}

final class SocialLoginService: NSObject, SocialLoginServiceType {
  
  enum SocialLoginError: Error {
    case parsingError
  }
  
  typealias SocialLoginResult = (token: String?, type: SocialLoginType, error: Error?)
  
  let tokenProvider = PublishSubject<SocialLoginResult>()
  let disposeBag = DisposeBag()
  
  let networking = Networking(
    plugins: [
      NetworkLoggerPlugin()
    ]
  )
}

extension SocialLoginService {
  
  func signIn(type: SocialLoginType) {
    switch type {
    case .apple:
      signInWithApple()
    }
  }
  
  private func signInWithApple() {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]

    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = self
    controller.presentationContextProvider = self
    controller.performRequests()
  }
}

// MARK: - ASAuthorizationControllerDelegate
extension SocialLoginService: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
      case let appleIdCredential as ASAuthorizationAppleIDCredential:
        if let token = appleIdCredential.identityToken,
           let tokenString = String(data: token, encoding: .utf8) {

          tokenProvider.onNext((tokenString, .apple, nil))
        } else {
          tokenProvider.onNext((nil, .apple, SocialLoginError.parsingError))
        }
      default:
        break
    }
  }
  
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    tokenProvider.onNext((nil, .apple, error))
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension SocialLoginService: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return UIApplication.shared.windows.last!
  }
}
