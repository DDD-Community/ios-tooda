//
//  RxAuthorization.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import Photos

import RxSwift
import RxCocoa

protocol AppAuthorizationType {
  var pushStatus: Observable<AuthorizationStatus> { get }
  var requestPush: Observable<Bool> { get }
  var photoLibrary: Observable<AuthorizationStatus> { get }
}

enum AuthorizationStatus {
  case authorized
  case denied
  case notDetermined
}

class RxAuthorization: AppAuthorizationType {
  var pushStatus: Observable<AuthorizationStatus> {
    return Observable.create { observer -> Disposable in
      let pushCenter = UNUserNotificationCenter.current()
      
      pushCenter.getNotificationSettings { settings in
        switch settings.authorizationStatus {
          
          case .authorized:
            observer.onNext(AuthorizationStatus.authorized)
            observer.onCompleted()
            return
          case .notDetermined:
            observer.onNext(AuthorizationStatus.notDetermined)
            observer.onCompleted()
            return
          default:
            observer.onNext(AuthorizationStatus.denied)
            observer.onCompleted()
            return
        }
      }
      
      return Disposables.create()
    }
  }
  
  var requestPush: Observable<Bool> {
    return Observable.create { observer -> Disposable in
      let pushCenter = UNUserNotificationCenter.current()
      let options: UNAuthorizationOptions = [.alert, .badge, .sound]
      
      pushCenter.requestAuthorization(options: options) { allowed, error in
        if let error = error {
          observer.onError(error)
          return
        }
        observer.onNext(allowed)
        observer.onCompleted()
        return
        
      }
      return Disposables.create()
    }
  }
  
  var photoLibrary: Observable<AuthorizationStatus> {
    return Observable.create { observer -> Disposable in
      
      if #available(iOS 14, *) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly, handler: { status in
          switch status {
            case .authorized, .limited:
              observer.onNext(.authorized)
              observer.onCompleted()
            case .restricted, .denied:
              observer.onNext(.denied)
              observer.onCompleted()
            default:
              observer.onNext(.notDetermined)
              observer.onCompleted()
          }
        })
      } else {
        PHPhotoLibrary.requestAuthorization({ status in
          switch status {
            case .authorized:
              observer.onNext(.authorized)
              observer.onCompleted()
            case .restricted, .denied:
              observer.onNext(.denied)
              observer.onCompleted()
            default:
              observer.onNext(.notDetermined)
              observer.onCompleted()
          }
        })
      }
      
      return Disposables.create()
    }
  }
}
