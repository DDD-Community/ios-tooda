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
    let payload: Payload
  }

  // MARK: Reactor

  enum Action {
    case loadData
    case back
    case editNote
  }

  enum Mutation {
    case setNoteDetailSectionModel([NoteDetailSection])
    case fetchNote(Note)
  }

  struct State {
    var sectionModel: [NoteDetailSection]
    let noteID: Int
    var note: Note?
    
    static func generateInitialState(noteID: Int) -> State {
      return State(sectionModel: [], noteID: noteID)
    }
  }


  // MARK: Properties

  private let dependency: Dependency
  
  private let noteUpdateCompletionRelay: PublishRelay<Note> = PublishRelay()

  let initialState: State

  init(dependency: Dependency) {
    self.dependency = dependency
    self.initialState =
      State.generateInitialState(noteID: dependency.payload.id)
  }
  
  func transform(action: Observable<Action>) -> Observable<Action> {
    return Observable.merge(
      action,
      self.noteUpdateCompletionRelay
        .map { _ in Action.loadData }
    )
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
    }
  }
  
  private func loadDataMutation() -> Observable<Mutation> {
    return dependency.service.request(NoteAPI.detail(id: initialState.noteID))
      .toodaMap(Note.self)
      .asObservable()
      .flatMap { note -> Observable<Mutation> in
        
        let stockSectionItems = note.noteStocks?
          .map { NoteStockCellReactor.init(payload: .init(name: $0.name, rate: $0.changeRate ?? 0.0)) }
          .map { NoteDetailSectionItem.stock($0) }
        
        let stockSection = NoteDetailSection(
          identity: .stock,
          items: stockSectionItems ?? []
        )
        
        let linkSectionItems = note.noteLinks?
          .compactMap { $0.url }
          .map { NoteLinkCellReactor.init(dependency: .init(service: self.dependency.linkPreviewService), payload: $0) }
          .map { NoteDetailSectionItem.link($0) }
        
        let linkSection = NoteDetailSection(
          identity: .link,
          items: linkSectionItems ?? []
        )
        
        let sectionModels = [
          NoteDetailSection(
            identity: .header,
            items: [
              .sticker(note.sticker ?? Sticker.wow),
              .title(note.title, note.updatedAt?.string() ?? note.createdAt?.string()),
              .content(note.content)
            ]
          ),
          stockSection,
          linkSection
        ]
        return Observable<Mutation>.concat([
          .just(Mutation.setNoteDetailSectionModel(sectionModels)),
          .just(Mutation.fetchNote(note))
        ])
      }
  }
  
  private func editNote() {
    guard let note = self.currentState.note else { return }
    
    let noteRequestDTO = NoteRequestDTO(id: "\(note.id)",
                                        updatedAt: note.updatedAt?.string(),
                                        createdAt: note.createdAt?.string(),
                                        title: note.title,
                                        content: note.content,
                                        stocks: note.noteStocks?.map { $0 } ?? [],
                                        links: note.noteLinks?.compactMap { $0.url } ?? [],
                                        images: note.noteImages.map { $0.imageURL },
                                        sticker: note.sticker ?? .wow)
    
    let dateString = note.createdAt?.string(.dot) ?? ""
    
    self.dependency.coordinator.transition(to: .modifyNote(dateString: dateString,
                                                           note: noteRequestDTO,
                                                           updateCompletonRelay: self.noteUpdateCompletionRelay),
                                           using: .modal, animated: true, completion: nil)
  }
}


// MARK: - Reduce

extension NoteDetailReactor {

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case let .setNoteDetailSectionModel(sectionModel):
      newState.sectionModel = sectionModel
    case let .fetchNote(note):
      newState.note = note
    }
    
    return newState
  }
}
