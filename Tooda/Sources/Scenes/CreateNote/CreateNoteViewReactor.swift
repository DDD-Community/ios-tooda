//
//  CreateNoteViewReactor.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import ReactorKit
import Then
import RxRelay

final class CreateNoteViewReactor: Reactor {
  
  enum ViewPresentType {
    case showAlert(String)
    case showPermission(String)
    case showPhotoPicker
  }
  
  let scheduler: Scheduler = MainScheduler.asyncInstance

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let authorization: AppAuthorizationType
    let linkPreviewService: LinkPreViewServiceType
    let createDiarySectionFactory: CreateNoteSectionType
  }

  enum Action {
    case initializeForm
    case dismissView
    case regist
    case didSelectedImageItem(IndexPath)
    case uploadImage(Data)
    case showAddStockView
    case stockItemDidAdded(NoteStock)
    case linkURLDidAdded(String)
    case textValueDidChanged(title: String, content: String)
    case linkButtonDidTapped
  }

  enum Mutation {
    case initializeForm([NoteSection])
    case present(ViewPresentType)
    case fetchImageSection(NoteSectionItem)
    case fetchStockSection(NoteSectionItem)
    case fetchLinkSection(NoteSectionItem)
    case shouldRegisterButtonEnabeld(Bool)
  }

  struct State: Then {
    var sections: [NoteSection] = []
    var presentType: ViewPresentType?
    var shouldReigsterButtonEnabled: Bool = false
  }

  let initialState: State

  let dependency: Dependency
  
  private let addStockCompletionRelay: PublishRelay<NoteStock> = PublishRelay()

  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState = State()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initializeForm:
      return .just(Mutation.initializeForm(makeSections()))
    case .didSelectedImageItem(let index):
      return checkAuthorizationAndSelectedItem(indexPath: index)
    case .uploadImage(let data):
      return self.uploadImage(data)
        .flatMap { [weak self] response -> Observable<Mutation> in
        return self?.fetchImageSection(with: response) ?? .empty()
      }
    case .showAddStockView:
      return presentAddStockView()
    case .stockItemDidAdded(let stock):
      return self.makeStockSectionItem(stock)
    case .linkURLDidAdded(let url):
      return self.makeLinkSectionItem(url)
    case .textValueDidChanged(let title, let content):
      return self.makeTitleAndContent(title, content)
    case .linkButtonDidTapped:
        return self.linkButtonDidTapped()
    case .dismissView:
        return dismissView()
    default:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    
    var newState = State().with {
      $0.sections = state.sections
      $0.shouldReigsterButtonEnabled = state.shouldReigsterButtonEnabled
      $0.presentType = nil
    }
    
    switch mutation {
    case .initializeForm(let sections):
      newState.sections = sections
    case .present(let type):
      newState.presentType = type
    case .fetchImageSection(let sectionItem):
      newState.sections[NoteSection.Identity.image.rawValue].items = [sectionItem]
    case .fetchStockSection(let sectionItem):
      newState.sections[NoteSection.Identity.stock.rawValue].items.append(sectionItem)
    case .fetchLinkSection(let sectionItem):
      newState.sections[NoteSection.Identity.link.rawValue].items.append(sectionItem)
    case .shouldRegisterButtonEnabeld(let enabled):
      newState.shouldReigsterButtonEnabled = enabled
    }

    return newState
  }
  
  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(action, self.addStockCompletionRelay.map { Action.stockItemDidAdded($0) })
  }

  private func makeSections() -> [NoteSection] {
    let sections = self.dependency.createDiarySectionFactory(self.dependency.authorization, self.dependency.coordinator)
    return sections
  }
  
  private func didSelectedImageItem(_ indexPath: IndexPath) -> Observable<Mutation> {
    
    let section = self.currentState.sections[NoteSection.Identity.image.rawValue]
    
    guard let imageCellReactor = section.items.compactMap { items -> NoteImageCellReactor? in
      if case let NoteSectionItem.image(value) = items {
        return value
      } else {
        return nil
      }
    }.first else { return .empty() }
    
    let imageItemSection = imageCellReactor.currentState.sections[indexPath.section]
    
    let imageSectionItem = imageItemSection.items[indexPath.row]
    
    switch imageSectionItem {
      case .empty:
        guard imageCellReactor.currentState.sections[NoteImageSection.Identity.item.rawValue].items.count < 3 else {
          return .just(.present(.showAlert("이미지는 최대 3개까지 등록 가능합니다.")))
        }
        
        return .just(.present(.showPhotoPicker))
      case .item:
        imageCellReactor.action.onNext(.removeImage(indexPath))
    }
    
    return .empty()
  }
  
  private func checkAuthorizationAndSelectedItem(indexPath: IndexPath) -> Observable<Mutation> {
    let service = self.dependency.authorization
    
    return service.photoLibrary.flatMap { [weak self] status -> Observable<Mutation> in
      switch status {
        case .authorized:
          guard let mutation = self?.didSelectedImageItem(indexPath) else { return .empty() }
          return mutation
        default:
          return .just(.present(.showPermission("테스트")))
      }
    }
  }
}

// MARK: Upload Images

extension CreateNoteViewReactor {
  private func uploadImage(_ data: Data) -> Observable<String> {
    return self.dependency.service.request(NoteAPI.addImage(data: data))
      .map([String].self)
      .asObservable()
      .flatMap { dataList -> Observable<String> in
        guard let response = dataList.first else { return .empty() }
        return .just(response)
      }
  }
}

// MARK: - Fetch ImageSections

extension CreateNoteViewReactor {
  private func fetchImageSection(with imageURL: String) -> Observable<Mutation> {
    let section = self.currentState.sections[NoteSection.Identity.image.rawValue]

    guard let imageCellReactor = section.items.compactMap({ items -> NoteImageCellReactor? in
      if case let NoteSectionItem.image(value) = items {
        return value
      } else {
        return nil
      }
    }).first else { return .empty() }


    imageCellReactor.action.onNext(.addImage(imageURL))

    return .empty()
  }
}

// MARK: Add Stock Items

extension CreateNoteViewReactor {
  private func makeStockSectionItem(_ stock: NoteStock) -> Observable<Mutation> {
    let reator = NoteStockCellReactor(
      payload: .init(name: stock.name,
                     rate: stock.changeRate ?? 0.0)
    )
    
    let sectionItem = NoteSectionItem.stock(reator)
    
    return .just(.fetchStockSection(sectionItem))
  }
  
  private func makeLinkSectionItem(_ url: String) -> Observable<Mutation> {
    let linkReactor = NoteLinkCellReactor(dependency: .init(
      service: self.dependency.linkPreviewService),
                                          payload: url
    )
    
    let linkSectionItem: NoteSectionItem = NoteSectionItem.link(linkReactor)
    
    return .just(.fetchLinkSection(linkSectionItem))
  }
}

// MARK: TextInput DidChanged
extension CreateNoteViewReactor {
  private func makeTitleAndContent(_ title: String, _ content: String) -> Observable<Mutation> {
    
    let shouldButtonEnabled = !(title.isEmpty || content.isEmpty)
    
    // TODO: 노트 등록을 위한 title과 content를 State에 전달할 Mutation을 연결할 예정이에요.
    return .just(.shouldRegisterButtonEnabeld(shouldButtonEnabled))
  }
}

// MARK: LinkButton DidTapped

extension CreateNoteViewReactor {
  private func linkButtonDidTapped() -> Observable<Mutation> {
    
    return .empty()
  }
}

typealias CreateNoteSectionType = (AppAuthorizationType, AppCoordinatorType) -> [NoteSection]

let createDiarySectionFactory: CreateNoteSectionType = { authorization, coordinator -> [NoteSection] in
  var sections: [NoteSection] = [
    NoteSection(identity: .content, items: []),
    NoteSection(identity: .stock, items: []),
    NoteSection(identity: .addStock, items: []),
    NoteSection(identity: .link, items: []),
    NoteSection(identity: .image, items: [])
  ]

  let contentReactor: NoteContentCellReactor = NoteContentCellReactor()
  let contentSectionItem: NoteSectionItem = NoteSectionItem.content(contentReactor)
  
  let addStockReactor: EmptyNoteStockCellReactor = EmptyNoteStockCellReactor()
  let addStockSectionItem: NoteSectionItem = NoteSectionItem.addStock(addStockReactor)
  
  let imageReactor: NoteImageCellReactor = NoteImageCellReactor(dependency: .init(factory: noteImageSectionFactory))
  let imageSectionItem: NoteSectionItem = NoteSectionItem.image(imageReactor)

  sections[NoteSection.Identity.content.rawValue].items = [contentSectionItem]
  sections[NoteSection.Identity.addStock.rawValue].items = [addStockSectionItem]
  sections[NoteSection.Identity.image.rawValue].items = [imageSectionItem]

  return sections
}

// MARK: - Dependency Logic

extension CreateNoteViewReactor {
  private func dismissView() -> Observable<Mutation> {
    self.dependency.coordinator.close(style: .dismiss,
                                      animated: true,
                                      completion: nil)
    
    return .empty()
  }
  
  private func presentAddStockView() -> Observable<Mutation> {
    self.dependency.coordinator.transition(
      to: .addStock(completion: self.addStockCompletionRelay),
      using: .modal,
      animated: true,
      completion: nil
    )
    
    return .empty()
  }
}
