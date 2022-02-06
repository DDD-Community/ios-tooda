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

// TODO: 노트 등록이 아닌 입력과 관련된 이름으로 변경해요.
final class CreateNoteViewReactor: Reactor {
  
  private enum Const {
    static let stockMaxCount: Int = 5
    static let linkMaxCount: Int = 2
    static let imageMaxCount: Int = 3
    
    static let networkingErrorMessage: String = "네트워크 연결에 실패했습니다 :("
  }
  
  enum ViewPresentType {
    case showAlert(title: String?, message: String)
    case showPermission(String)
    case showImageSourceActionSheetView
    case showImagePickerView(ImagePickerType)
  }
  
  let scheduler: Scheduler = MainScheduler.asyncInstance

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let authorization: AppAuthorizationType
    let linkPreviewService: LinkPreViewServiceType
    let createDiarySectionFactory: CreateNoteSectionType?
    let modifiableNoteSectionFactory: ModifiableNoteSectionType?
    let noteEventBus: PublishSubject<NoteEventBus.Event>
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
    case makeTitleAndContent(title: String, content: String)
    case linkButtonDidTapped
    case registerButtonDidTapped
    case updateButtonDidTapped
    case stckerDidPicked(Sticker)
    case updateStikcerDidPicked(Sticker)
    case noteItemDidDeleted(IndexPath)
    case showStockItemEditView(IndexPath)
    case stockItemDidUpdated(NoteStock)
    case imagePickerDidTapped(ImagePickerType)
  }

  enum Mutation {
    case initializeForm([NoteSection])
    case present(ViewPresentType)
    case fetchImageSection(NoteSectionItem)
    case fetchStockSection(NoteSectionItem)
    case fetchLinkSection(NoteSectionItem)
    case shouldRegisterButtonEnabeld(Bool)
    case stockItemDidDeleted(Int)
    case linkItemDidDeleted(Int)
    case requestNoteDataDidChanged(NoteRequestDTO)
    case fetchEmptyStockItem([NoteSectionItem])
    case setSnackBarInfo(SnackBarManager.SnackBarInfo)
    case shouldKeyboardDismissed(Bool)
    case setLoading(Bool)
  }

  struct State: Then {
    var sections: [NoteSection] = []
    var presentType: ViewPresentType?
    var shouldReigsterButtonEnabled: Bool = false
    var requestNote: NoteRequestDTO = NoteRequestDTO()
    var snackBarInfo: SnackBarManager.SnackBarInfo?
    var shouldKeyboardDismissed: Bool?
    var isLoading: Bool = false
  }
  
  struct Payload {
    var routeToDetailRelay: PublishRelay<Int>?
  }

  let initialState: State
  
  private var lastEditableStockCellIndexPath: IndexPath?

  let dependency: Dependency
  
  let payload: Payload?
  
  // MARK: Global Events
  
  private let addStockCompletionRelay: PublishRelay<NoteStock> = PublishRelay()
  private let addLinkURLCompletionRelay: PublishRelay<String> = PublishRelay()
  private let addStickerCompletionRelay: PublishRelay<Sticker> = PublishRelay()
  private let updateStickerCompletionRelay: PublishRelay<Sticker> = PublishRelay()
  
  private let stockItemEditCompletionRelay: PublishRelay<NoteStock> = PublishRelay()
  
  private let snackBarMutationStream = PublishRelay<SnackBarManager.SnackBarInfo>()
  
  init(dependency: Dependency, modifiableNote: NoteRequestDTO?, payload: Payload?) {
    self.dependency = dependency
    self.payload = payload
    
    if let requestNote = modifiableNote {
      self.initialState = State(requestNote: requestNote)
    } else {
      self.initialState = State()
    }
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .initializeForm:
      return .just(Mutation.initializeForm(makeSections()))
    case .didSelectedImageItem(let index):
        return didSelectedImageItem(index)
    case .uploadImage(let data):
      return Observable.concat([
        .just(Mutation.setLoading(true)),
        self.uploadImage(data)
          .flatMap { [weak self] imageURL -> Observable<Mutation> in
            return self?.fetchImageSection(with: imageURL) ?? .empty()
          },
        .just(Mutation.setLoading(false))
      ])
    case .showAddStockView:
      return presentAddStockView()
    case .stockItemDidAdded(let stock):
      return self.makeStockSectionItem(stock)
    case .linkURLDidAdded(let url):
      return self.makeLinkSectionItem(url)
    case .makeTitleAndContent(let title, let content):
      return self.makeTitleAndContent(title, content)
    case .linkButtonDidTapped:
        return self.linkButtonDidTapped()
    case .registerButtonDidTapped:
        return self.registerButtonDidTapped()
    case .updateButtonDidTapped:
        return self.updateButtonDidTapped()
    case .stckerDidPicked(let sticker):
        return self.addStickerAndAddNote(sticker)
    case .updateStikcerDidPicked(let sticker):
        return self.addStickerAndUpdateNote(sticker)
    case .noteItemDidDeleted(let indexPath):
        return self.noteItemDidDeleted(indexPath)
    case .showStockItemEditView(let index):
        return self.showStockItemEditView(index)
    case .stockItemDidUpdated(let stock):
        return self.stockItemDidUpdated(stock)
    case .dismissView:
        return dismissView()
    case .imagePickerDidTapped(let pickerType):
        return imagePickerDidTapped(pickerType)
    default:
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    
    var newState = State().with {
      $0.sections = state.sections
      $0.shouldReigsterButtonEnabled = state.shouldReigsterButtonEnabled
      $0.presentType = nil
      $0.requestNote = state.requestNote
      $0.snackBarInfo = nil
      $0.shouldKeyboardDismissed = nil
      $0.isLoading = false
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
    case .stockItemDidDeleted(let row):
      newState.sections[NoteSection.Identity.stock.rawValue].items.remove(at: row)
    case .linkItemDidDeleted(let row):
      newState.sections[NoteSection.Identity.link.rawValue].items.remove(at: row)
    case .requestNoteDataDidChanged(let data):
      newState.requestNote = data
    case .fetchEmptyStockItem(let sectionItems):
      newState.sections[NoteSection.Identity.addStock.rawValue].items = sectionItems
    case .setSnackBarInfo(let info):
      newState.snackBarInfo = info
    case .shouldKeyboardDismissed(let dismissed):
      newState.shouldKeyboardDismissed = dismissed
    case .setLoading(let isLoading):
      newState.isLoading = isLoading
    }

    return newState
  }
  
  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(
      action,
      self.addStockCompletionRelay
        .map { Action.stockItemDidAdded($0) },
      self.addLinkURLCompletionRelay
        .map { Action.linkURLDidAdded($0) },
      self.addStickerCompletionRelay
        .map { Action.stckerDidPicked($0) },
      self.stockItemEditCompletionRelay
        .map { Action.stockItemDidUpdated($0) },
      self.updateStickerCompletionRelay
        .map { Action.updateStikcerDidPicked($0) }
    )
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(
      mutation,
      snackBarMutationStream.asObservable()
        .map { Mutation.setSnackBarInfo($0) }
    )
  }

  private func makeSections() -> [NoteSection] {
    
    if let createSectionFactory = self.dependency.createDiarySectionFactory {
      let sections = createSectionFactory(self.dependency.authorization, self.dependency.coordinator)
      return sections
    }
    
    if let modifySectionFactory = self.dependency.modifiableNoteSectionFactory {
      let sections = modifySectionFactory(self.currentState.requestNote, self.dependency.linkPreviewService)
      return sections
    }
    
    return []
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
        guard imageCellReactor.currentState.sections[NoteImageSection.Identity.item.rawValue].items.count < Const.imageMaxCount else {
          return .just(.present(.showAlert(title: "사진은 최대 \(Const.imageMaxCount)개까지\n추가할 수 있어요.", message: "사진을 추가하시려면 기존 사진을\n삭제 후 추가해주세요.")))
        }
        
        return .just(.present(.showImageSourceActionSheetView))
      case .item:
        imageCellReactor.action.onNext(.removeImage(indexPath))
        
        var requestNote = self.currentState.requestNote
        requestNote.images.remove(at: indexPath.row)
        
        return .just(.requestNoteDataDidChanged(requestNote))
    }
    
    return .empty()
  }
  
  
  private func imagePickerDidTapped(_ pickerType: ImagePickerType) -> Observable<Mutation> {
    switch pickerType {
      case .photo:
        return showPhotoPickerIfNeeded()
      case .camera:
        return showCameraPickerIfNeeded()
    }
  }
  
  private func showPhotoPickerIfNeeded() -> Observable<Mutation> {
    return self.dependency.authorization.photoLibrary.flatMap { status -> Observable<Mutation> in
      switch status {
        case .authorized:
          return .just(.present(.showImagePickerView(.photo)))
        default:
          return .just(.present(.showPermission("앨범에서 사진을 선택하기 위해 권한 설정이 필요합니다.")))
      }
    }
  }
  
  private func showCameraPickerIfNeeded() -> Observable<Mutation> {
    return self.dependency.authorization.camera.flatMap { status -> Observable<Mutation> in
      switch status {
        case .authorized:
          return .just(.present(.showImagePickerView(.camera)))
        default:
          return .just(.present(.showPermission("사진을 촬영하기 위해 권한 설정이 필요합니다.")))
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
    
    var requestNote = self.currentState.requestNote
    requestNote.images.append(imageURL)
    return .just(.requestNoteDataDidChanged(requestNote))
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
    
    var requestNote = self.currentState.requestNote
    requestNote.stocks.append(stock)
    
    return .concat([
      .just(.requestNoteDataDidChanged(requestNote)),
      .just(.fetchStockSection(sectionItem)),
      self.emptyStockItemDidChanged(by: requestNote.stocks.count)
    ])
  }
  
  private func makeLinkSectionItem(_ urlString: String) -> Observable<Mutation> {
    guard URL(string: urlString) != nil else {
      return .concat([
        .just(.shouldKeyboardDismissed(true)),
        .just(.present(.showAlert(title: "추가할 수 없는 URL이에요.",
                                       message: "정확한 URL을 다시 입력해주세요.")))
      ])
    }
    
    let linkReactor = NoteLinkCellReactor(dependency: .init(
      service: self.dependency.linkPreviewService),
                                          payload: urlString
    )
    
    let linkSectionItem: NoteSectionItem = NoteSectionItem.link(linkReactor)
    
    var requestNote = self.currentState.requestNote
    requestNote.links.append(urlString)
    
    return .concat([
      .just(.requestNoteDataDidChanged(requestNote)),
      .just(.fetchLinkSection(linkSectionItem))
    ])
  }
}

// MARK: TextInput DidChanged
extension CreateNoteViewReactor {
  private func makeTitleAndContent(_ title: String, _ content: String) -> Observable<Mutation> {
    
    let shouldButtonEnabled = !(title.isEmpty || content.isEmpty)
    
    var requestNote = self.currentState.requestNote
    requestNote.title = title
    requestNote.content = content
    
    return Observable.concat([
      .just(.requestNoteDataDidChanged(requestNote)),
      .just(.shouldRegisterButtonEnabeld(shouldButtonEnabled))
    ])
  }
}

// MARK: LinkButton DidTapped

extension CreateNoteViewReactor {
  private func linkButtonDidTapped() -> Observable<Mutation> {
    
    let maxItemCount: Int = Const.linkMaxCount
    
    if self.currentState.sections[NoteSection.Identity.link.rawValue].items.count < maxItemCount {
      self.dependency.coordinator.transition(to: .popUp(type: .textInput(self.addLinkURLCompletionRelay)),
                                             using: .modal,
                                             animated: false)
    } else {
      return .just(.present(.showAlert(title: "링크는 최대 \(maxItemCount)개까지\n추가할 수 있어요.",
                                      message: "링크를 추가하시려면 기존 링크를\n삭제 후 추가해주세요.")))
    }
    
    return .empty()
  }
}

// MARK: RegisterButton DidTapped

extension CreateNoteViewReactor {
  private func registerButtonDidTapped() -> Observable<Mutation> {
    
self.dependency.coordinator.transition(
     to: .popUp(type: .list(self.addStickerCompletionRelay)),
     using: .modal,
     animated: false,
     completion: nil
)
    
    return .empty()
  }
  
  private func addStickerAndAddNote(_ sticker: Sticker) -> Observable<Mutation> {
    var requestNote = self.currentState.requestNote
    requestNote.sticker = sticker
    
    return Observable.concat([
      .just(.shouldKeyboardDismissed(true)),
      .just(.requestNoteDataDidChanged(requestNote)),
      self.registNoteAndDismissView(requestNote)
    ])
  }
  
  private func registNoteAndDismissView(_ requestNote: NoteRequestDTO) -> Observable<Mutation> {
    return self.dependency.service.request(NoteAPI.create(dto: requestNote))
      .toodaMap(Note?.self)
      .catch({ [weak self] _ in
        self?.snackBarMutationStream.accept(.init(
          title: Const.networkingErrorMessage,
          type: .negative
        ))
        return Single.just(nil)
      })
      .asObservable()
      .compactMap { $0 }
      .flatMap { [weak self] note -> Observable<Mutation> in
        if "\(note.id)".isNotEmpty {
          return self?.dimissViewWithAddCompletion(note) ?? .empty()
        } else {
          return .empty()
        }
      }
  }
  
  private func dimissViewWithAddCompletion(_ note: Note) -> Observable<Mutation> {
    
    guard "\(note.id)".isNotEmpty else { return .empty() }
    
    self.dependency.noteEventBus.onNext(.createNote(note))
    
    self.dependency.coordinator.close(
      style: .dismiss,
      animated: true,
      completion: { [weak self] in
        self?.payload?.routeToDetailRelay?.accept(note.id)
      }
    )
    
    return .empty()
  }
}

// MARK: - Update Button Did Tap

extension CreateNoteViewReactor {
  
  private func updateButtonDidTapped() -> Observable<Mutation> {
    
    self.dependency.coordinator.transition(to: .popUp(type: .list(self.updateStickerCompletionRelay)),
                                           using: .modal,
                                           animated: false,
                                           completion: nil)
    
    return .empty()
  }
  
  private func addStickerAndUpdateNote(_ sticker: Sticker) -> Observable<Mutation> {
    var requestNote = self.currentState.requestNote
    requestNote.sticker = sticker
    
    return Observable.concat([
      .just(.shouldKeyboardDismissed(true)),
      .just(.requestNoteDataDidChanged(requestNote)),
      self.updateNoteAndDismissView(requestNote)
    ])
  }
  
  private func updateNoteAndDismissView(_ requestNote: NoteRequestDTO) -> Observable<Mutation> {
    return self.dependency.service.request(NoteAPI.update(dto: requestNote))
      .toodaMap(Note?.self)
      .catch({ [weak self] _ in
        self?.snackBarMutationStream.accept(.init(
          title: Const.networkingErrorMessage,
          type: .negative
        ))
        return Single.just(nil)
      })
      .asObservable()
      .compactMap { $0 }
      .flatMap { [weak self] note -> Observable<Mutation> in
        return self?.dimissViewWithUpdateCompletion(note) ?? .empty()
      }
  }
  
  private func dimissViewWithUpdateCompletion(_ note: Note) -> Observable<Mutation> {
    
    guard "\(note.id)".isNotEmpty else { return .empty() }
    
    self.dependency.noteEventBus.onNext(.editNode(note))
    
    self.dependency.coordinator.close(
      style: .dismiss,
      animated: true,
      completion: nil
    )
    
    return .empty()
  }
}

// MARK: - StockItem Edit & Delete

extension CreateNoteViewReactor {
  private func noteItemDidDeleted(_ indexPath: IndexPath) -> Observable<Mutation> {
    
    guard let section = self.currentState.sections[safe: indexPath.section],
          let sectionItem = section.items[safe: indexPath.row] else { return .empty() }
    
    var requestNote = self.currentState.requestNote
    
    var changedMutation: Observable<Mutation>
    
    let row = indexPath.row
    
    switch sectionItem {
      case .stock:
        requestNote.stocks.remove(at: row)
        changedMutation = .just(.stockItemDidDeleted(row))
      case .link:
        requestNote.links.remove(at: row)
        changedMutation = .just(.linkItemDidDeleted(row))
      case .addStock, .content, .image:
        changedMutation = .empty()
    }
    
    return Observable.concat([
      .just(.requestNoteDataDidChanged(requestNote)),
      self.emptyStockItemDidChanged(by: requestNote.stocks.count),
      changedMutation
    ])
  }
  
  private func showStockItemEditView(_ index: IndexPath) -> Observable<Mutation> {
    
    guard let sectionItem = self.currentState.sections[NoteSection.Identity.stock.rawValue].items[safe: index.row] else {
      return .empty()
    }
    
    if case let NoteSectionItem.stock(reactor) = sectionItem {
      let stockItem = reactor.currentState.payload
      
      self.lastEditableStockCellIndexPath = index
      
      self.dependency.coordinator.transition(
        to: .stockRateInput(
          payload: .init(
            name: stockItem.name,
            completion: self.stockItemEditCompletionRelay
          ),
          editMode: .modify
        ),
        using: .modal,
        animated: true,
        completion: nil
      )
    }
    
    return .empty()
  }
  
  private func stockItemDidUpdated(_ stock: NoteStock) -> Observable<Mutation> {
    
    guard let indexPath = self.lastEditableStockCellIndexPath,
          let sectionItem = self.currentState.sections[NoteSection.Identity.stock.rawValue].items[safe: indexPath.row]
    else { return .empty() }
    
    if case let NoteSectionItem.stock(reactor) = sectionItem {
      reactor.action.onNext(.payloadDidChanged(stock))
      self.lastEditableStockCellIndexPath = nil
      
      var requestNote = self.currentState.requestNote
      requestNote.stocks.remove(at: indexPath.row)
      requestNote.stocks.insert(stock, at: indexPath.row)
      
      return .just(.requestNoteDataDidChanged(requestNote))
    }
    
    return .empty()
  }
}


// MARK: - Changed EmptyStockItem

extension CreateNoteViewReactor {
  private func emptyStockItemDidChanged(by count: Int) -> Observable<Mutation> {
    
    let itemMaxCount = Const.stockMaxCount
    
    var sectionItems: [NoteSectionItem] = []
    
    if count < itemMaxCount {
      sectionItems.append(NoteSectionItem.addStock)
    }
    
    return .just(.fetchEmptyStockItem(sectionItems))
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
  
  let contentReactor: NoteContentCellReactor = NoteContentCellReactor(payload: .init(title: "", content: ""))
  let contentSectionItem: NoteSectionItem = NoteSectionItem.content(contentReactor)
  
  let addStockReactor: EmptyNoteStockCellReactor = EmptyNoteStockCellReactor()
  let addStockSectionItem: NoteSectionItem = NoteSectionItem.addStock
  
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

typealias ModifiableNoteSectionType = (NoteRequestDTO, LinkPreViewServiceType) -> [NoteSection]

let modifiableNoteSectionFactory: (NoteRequestDTO, LinkPreViewServiceType) -> [NoteSection] = { note, previewService -> [NoteSection] in
  var sections: [NoteSection] = [
    NoteSection(identity: .content, items: []),
    NoteSection(identity: .stock, items: []),
    NoteSection(identity: .addStock, items: []),
    NoteSection(identity: .link, items: []),
    NoteSection(identity: .image, items: [])
  ]
  
  let contentReactor: NoteContentCellReactor = NoteContentCellReactor(payload: .init(title: note.title, content: note.content))
  let contentSectionItem: NoteSectionItem = NoteSectionItem.content(contentReactor)
  
  if note.stocks.isNotEmpty {
    let sectionItems = note.stocks
      .map { NoteStockCellReactor(payload: .init(name: $0.name, rate: $0.changeRate ?? 0)) }
      .map { NoteSectionItem.stock($0) }
    
    sections[NoteSection.Identity.stock.rawValue].items = sectionItems
  }
  
  let addStockReactor: EmptyNoteStockCellReactor = EmptyNoteStockCellReactor(itemCount: note.stocks.count)
  let addStockSectionItem: NoteSectionItem = NoteSectionItem.addStock
  
  let imageReactor: NoteImageCellReactor = NoteImageCellReactor(
    dependency: .init(
      factory: noteImageSectionFactory
    ),
    images: note.images.map { NoteImage(id: 0, imageURL: $0) }
  )
  
  let imageSectionItem: NoteSectionItem = NoteSectionItem.image(imageReactor)
  
  let linkSectionItems = note.links
    .map { NoteLinkCellReactor(dependency: .init(service: previewService), payload: $0) }
    .map { NoteSectionItem.link($0) }
  
  sections[NoteSection.Identity.link.rawValue].items = linkSectionItems
  
  sections[NoteSection.Identity.content.rawValue].items = [contentSectionItem]
  sections[NoteSection.Identity.addStock.rawValue].items = [addStockSectionItem]
  sections[NoteSection.Identity.image.rawValue].items = [imageSectionItem]
  
  return sections
}
