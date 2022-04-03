//
//  AppStepper.swift
//  Tooda
//
//  Created by Lyine on 2022/03/26.
//

import Foundation
import RxFlow
import RxSwift
import RxRelay

struct AppStepper: Stepper {
  let steps: PublishRelay<Step> = .init()
  
  struct Dependency {
    let persistenceManager: LocalPersistanceManagerType
  }
  
  private let dependency: Dependency
  private let disposeBag: DisposeBag = .init()
  
  init(dependency: Dependency) {
    self.dependency = dependency
  }
  
  func readyToEmitSteps() {
    let token: AppToken? = self.dependency.persistenceManager.objectValue(forKey: .appToken)
    
    Observable.just(token)
      .map { $0 != nil }
      .map { $0 ? ToodaStep.loginIsCompleted : ToodaStep.loginIsRequired }
      .bind(to: steps)
      .disposed(by: self.disposeBag)
  }
}
