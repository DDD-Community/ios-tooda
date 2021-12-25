//
//  HomeReactorTests.swift
//  ToodaTests
//
//  Created by 황재욱 on 2021/12/26.
//

@testable import Tooda

import Nimble
import Quick
import RxExpect
import RxTest
import Swinject

class HomeReactorTests: QuickSpec {
  
  var mockInject: MockInject!
  
  var reactor: HomeReactor!
  
  override func spec() {
    
    beforeEach {
      self.mockInject = MockInject(container: Container())
      self.reactor = HomeReactor(
        dependency: .init(
          service: self.mockInject.resolve(NetworkingProtocol.self),
          coordinator: self.mockInject.resolve(AppCoordinatorType.self)
        )
      )
    }
    
    describe("User arrives Home Scene") {
      context("when user-made notebook exists") {
        it("notelist is displayed") {
          
          let testExpect = RxExpect()
          
          testExpect.input(self.reactor.action, [.next(0, .load)])
          
          let notebookStream = self.reactor.state.map { $0.notebooks }.skip(1)
          testExpect.assert(notebookStream) { events in
            expect(events.first?.value.element?.first?.noteCount) == 10
          }
        }
      }
    }
  }
}
