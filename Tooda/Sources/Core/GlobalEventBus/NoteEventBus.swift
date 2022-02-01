//
//  NoteEventBus.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/01/23.
//

import RxSwift

enum NoteEventBus {

  static let event = PublishSubject<Event>()

  enum Event {
    case createNote(Note)
    case editNode(Note)
    case deleteNote(Note)
  }
}
