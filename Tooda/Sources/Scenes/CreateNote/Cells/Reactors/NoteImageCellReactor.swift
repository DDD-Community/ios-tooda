//
//  DiaryImageCellReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import ReactorKit

enum AppError: Error {
  case capturingFailed
}

final class NoteImageCellReactor: Reactor {
  
  let scheduler: Scheduler = MainScheduler.asyncInstance
  
  struct Dependency {
    let factory: NoteImageSectionType
    let authorizationService: AppAuthorizationType
    let coordinator: AppCoordinatorType
  }
  
  enum Action {
    case initiailizeSection
    case didSelectedItem(IndexPath)
    // TODO: 이미지 추가 로직
//    case addImage
  }

  enum Mutation {
    case fetchSection([NoteImageSection])
    case didSelctedItem(IndexPath)
    case requestPermissionMessage(String)
    case showAlertMessage(String?)
    case addImage
    case detailImage
//    case addImage([NoteImageSectionItem])
  }

  struct State {
    var sections: [NoteImageSection]
    var requestPermissionMessage: String?
    var showAlertMessage: String?
  }

  let initialState: State
  let dependency: Dependency
  
  let disposeBag: DisposeBag = DisposeBag()

  init(dependency: Dependency) {
    self.dependency = dependency
    initialState = State(sections: [])
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .initiailizeSection:
        return .just(Mutation.fetchSection(self.generateSection(images: testNotes)))
      case .didSelectedItem(let indexPath):
        return self.checkAuthorizationAndSelectedItem(indexPath: indexPath)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
      case .fetchSection(let sections):
        newState.sections = sections
      case .requestPermissionMessage(let message):
        newState.requestPermissionMessage = message
      case .showAlertMessage(let message):
        newState.showAlertMessage = message
      case .addImage:
        print("이미지 추가")
      case .detailImage:
        print("이미지 상세")
      default:
        break
    }
    
    return newState
  }
  
  private func generateSection(images: [NoteImage]) -> [NoteImageSection] {
    return self.dependency.factory(images)
  }
  
  private func checkAuthorizationAndSelectedItem(indexPath: IndexPath) -> Observable<Mutation> {
    let service = self.dependency.authorizationService
    
    return service.photoLibrary.flatMap { [weak self] status -> Observable<Mutation> in
      switch status {
        case .authorized:
          guard let mutation = self?.didSelectedItem(indexPath) else { return .empty() }
          return mutation
        default:
          return .just(Mutation.requestPermissionMessage("테스트"))
      }
    }
  }
  
  private func didSelectedItem(_ indexPath: IndexPath) -> Observable<Mutation> {
    let selectedSection = indexPath.section
    
    guard let matched = NoteImageSection.Identity.allCases.first(where: { $0.rawValue == selectedSection }) else { return .empty() }
    
    switch matched {
      case .empty:
        
        let sectionItemsCount = self.currentState.sections[NoteImageSection.Identity.item.rawValue].items.count
        
        guard sectionItemsCount < 3 else { return .just(.showAlertMessage("아이템은 최대 3개 까지 등록 가능합니다.")) }
        
        return .concat([.just(.showAlertMessage(nil)), .just(.addImage)])
      case .item:
        return .concat([.just(.showAlertMessage(nil)), .just(.detailImage)])
    }
  }
}

// TODO: 
let testNotes: [NoteImage] = [
  .init(id: 0, url: "aaaaaaaaa"),
  .init(id: 1, url: "bbbbbbbbb"),
  .init(id: 2, url: "ccccccccc")
]

typealias NoteImageSectionType = ([NoteImage]) -> [NoteImageSection]

let noteImageSectionFactory: NoteImageSectionType = { images -> [NoteImageSection] in
  var sections: [NoteImageSection] = [
    NoteImageSection.init(identity: .empty, items: []),
    NoteImageSection.init(identity: .item, items: [])
  ]
  
  let emptyReactor: EmptyNoteImageItemCellReactor = EmptyNoteImageItemCellReactor()
  let emptySectionItem: NoteImageSectionItem = NoteImageSectionItem.empty(emptyReactor)
  sections[NoteImageSection.Identity.empty.rawValue].items = [emptySectionItem]
  
  let imageSectionItems = images.map { NoteImageItemCellReactor(item: $0) }.map { NoteImageSectionItem.item($0)}
  sections[NoteImageSection.Identity.item.rawValue].items = imageSectionItems
  
  return sections
}
