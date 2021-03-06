//
//  NoteDetailReactor.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/01/01.
//

import Foundation

import ReactorKit
import RxSwift
import RxRelay

final class NoteDetailReactor: Reactor {
  
  struct Payload {
    let id: Int
  }

  // MARK: Dependency

  struct Dependency {
    let service: NetworkingProtocol
    let coordinator: AppCoordinatorType
    let linkPreviewService: LinkPreViewServiceType
    let noteEventBus: PublishSubject<NoteEventBus.Event>
  }

  // MARK: Constant

  private enum Text {
    static let networkingErrorMessage = "네트워크 연결에 실패했습니다 :("
  }

  // MARK: Reactor

  enum Action {
    case loadData
    case back
    case editNote
    case deleteNote
    case linkItemDidTapped(String)
  }

  enum Mutation {
    case setNoteDetailSectionModel([NoteDetailSection])
    case fetchNote(Note)
    case appendImageSection([NoteDetailSectionItem])
    case setSnackbarInfo(SnackBarManager.SnackBarInfo)
  }

  struct State {
    var sectionModel: [NoteDetailSection]
    let noteID: Int
    var note: Note?
    var snackbarInfo: SnackBarManager.SnackBarInfo?
    
    static func generateInitialState(noteID: Int) -> State {
      return State(sectionModel: [], noteID: noteID)
    }
    
    
  }


  // MARK: Properties

  private let dependency: Dependency

  let initialState: State
  
  let payload: Payload

  private let snackbarEvent = PublishSubject<SnackBarManager.SnackBarInfo>()

  init(dependency: Dependency, payload: Payload) {
    self.dependency = dependency
    self.payload = payload
    self.initialState =
      State.generateInitialState(noteID: payload.id)
  }
}


// MARK: - Mutate

extension NoteDetailReactor {

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .loadData:
      return loadDataMutation()
    case .back:
      self.dependency.coordinator.close(
        style: .pop,
        animated: true,
        completion: nil
      )
      return .empty()
      case .editNote:
        self.editNote()
        return .empty()
    case .deleteNote:
      return deleteNoteMutation()
    case .linkItemDidTapped(let urlString):
      return linkItemDidTapped(urlString)
    }
  }
  
  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    return Observable.merge(
      mutation,
      dependency.noteEventBus
        .flatMap { [weak self] event -> Observable<Mutation> in
          guard let self = self else { return Observable<Mutation>.empty() }
          switch event {
          case let .editNode(note):
            return self.applyModifiedNoteMutation(with: note)
          default:
            return Observable<Mutation>.empty()
          }
        }
    )
  }
  
  private func generateSectionModels(with note: Note) -> [NoteDetailSection] {
    let stockSectionItems = note.noteStocks?
      .map { NoteStockCellReactor.init(payload: .init(name: $0.name, rate: $0.changeRate ?? 0.0)) }
      .map { NoteDetailSectionItem.stock($0) }
    
    let stockSection = NoteDetailSection(
      identity: .stock,
      items: stockSectionItems ?? []
    )
    
    let linkSectionItems = note.noteLinks?
      .compactMap { $0.url }
      .map { NoteLinkCellReactor.init(dependency: .init(service: dependency.linkPreviewService), payload: $0) }
      .map { NoteDetailSectionItem.link($0) }
    
    let linkSection = NoteDetailSection(
      identity: .link,
      items: linkSectionItems ?? []
    )
    
    return [
      NoteDetailSection(
        identity: .header,
        items: [
          .sticker(note.sticker ?? Sticker.wow),
          .title(note.title, note.updatedAt ?? note.createdAt),
          .content(note.content)
        ]
      ),
      stockSection,
      linkSection,
      NoteDetailSection(identity: .image, items: [])
    ]
  }
  
  private func applyModifiedNoteMutation(with note: Note) -> Observable<Mutation> {
    
    let sectionModels = generateSectionModels(with: note)
    
    return Observable<Mutation>.concat([
      .just(Mutation.setNoteDetailSectionModel(sectionModels)),
      self.loadImageMutation(images: note.noteImages),
      .just(Mutation.fetchNote(note))
    ])
  }
  
  private func loadDataMutation() -> Observable<Mutation> {
    return dependency.service.request(NoteAPI.detail(id: initialState.noteID))
      .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
      .toodaMap(Note.self)
      .catch { [weak self] error in
        self?.snackbarEvent.onNext(.init(
          title: Text.networkingErrorMessage,
          type: .negative
        ))
        return .error(error)
      }
      .asObservable()
      .flatMap { [weak self] note -> Observable<Mutation> in
        guard let self = self else { return Observable<Mutation>.empty() }
        
        let sectionModels = self.generateSectionModels(with: note)
        
        return Observable<Mutation>.concat([
          .just(Mutation.setNoteDetailSectionModel(sectionModels)),
          self.loadImageMutation(images: note.noteImages),
          .just(Mutation.fetchNote(note))
        ])
      }
  }
  
  private func loadImageMutation(images: [NoteImage]) -> Observable<Mutation> {
    return Observable.create { observer in
      DispatchQueue.global(qos: .background).async {
        let imageSectionItems = images
          .compactMap { URL(string: $0.imageURL) }
          .compactMap { try? Data(contentsOf: $0) }
          .map { NoteDetailSectionItem.image($0) }
        
        observer.onNext(.appendImageSection(imageSectionItems))
        observer.onCompleted()
      }
      
      return Disposables.create()
    }
  }
  
  private func editNote() {
    guard let note = self.currentState.note else { return }
    
    let noteRequestDTO = NoteRequestDTO(id: "\(note.id)",
                                        updatedAt: note.updatedAt,
                                        createdAt: note.createdAt,
                                        title: note.title,
                                        content: note.content,
                                        stocks: note.noteStocks?.map { $0 } ?? [],
                                        links: note.noteLinks?.compactMap { $0.url } ?? [],
                                        images: note.noteImages.map { $0.imageURL },
                                        sticker: note.sticker ?? .wow)
    
    let dateString = note.createdAt?.string(.dot) ?? ""
    
    self.dependency.coordinator.transition(to: .modifyNote(dateString: dateString,
                                                           note: noteRequestDTO),
                                           using: .modal, animated: true, completion: nil)
  }
  
  private func deleteNoteMutation() -> Observable<Mutation> {
    let noteID = "\(self.currentState.noteID)"
    return self.dependency.service.request(NoteAPI.delete(id: noteID))
      .catch { [weak self] error in
        self?.snackbarEvent.onNext(.init(
          title: Text.networkingErrorMessage,
          type: .negative
        ))
        return .error(error)
      }
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Mutation> in
        
        guard let self = self,
                let note = self.currentState.note else { return .empty() }
        
        self.dependency.noteEventBus.onNext(.deleteNote(note))
        
        self.dependency.coordinator.close(
          style: .pop,
          animated: true,
          completion: nil
        )
        
        return .empty()
      }
  }
  
  private func linkItemDidTapped(_ urlString: String) -> Observable<Mutation> {
    guard let url = URL(string: urlString) else { return .empty() }
    
    self.dependency.coordinator.transition(to: .inAppBrowser(url: url),
                                           using: .modal,
                                           animated: true,
                                           completion: nil)
    
    return .empty()
  }
}


// MARK: - Reduce

extension NoteDetailReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    newState.snackbarInfo = nil

    switch mutation {
    case let .setNoteDetailSectionModel(sectionModel):
      newState.sectionModel = sectionModel
    case let .fetchNote(note):
      newState.note = note
    case let .appendImageSection(sectionItems):
      newState.sectionModel[NoteDetailSection.Identity.image.rawValue].items = sectionItems
    case let .setSnackbarInfo(info):
      newState.snackbarInfo = info
    }
    
    return newState
  }
}
