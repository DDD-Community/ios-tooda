//
//  NoteDetailViewController.swift
//  Tooda
//
//  Created by Jinsu Park on 2022/01/01.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

final class NoteDetailViewController: BaseViewController<NoteDetailReactor> {
  
  typealias Section = RxTableViewSectionedReloadDataSource<NoteDetailSection>
  
  lazy var dataSource: Section = Section(configureCell: { section, tableView, indexPath, item -> UITableViewCell in
    guard let sectionType = section.sectionModels[safe: indexPath.section]?.identity else {
      return UITableViewCell()
    }
    switch sectionType {
    case .header:
      
      if case let .sticker(sticker) = item {
        let noteStickerCell = tableView.dequeue(NoteStickerCell.self, indexPath: indexPath)
        noteStickerCell.configure(sticker: sticker)
        return noteStickerCell
      }
      
      if case let .title(title, date) = item {
        let noteDetailTitleCell = tableView.dequeue(NoteDetailTitleCell.self, indexPath: indexPath)
        noteDetailTitleCell.configure(title: title, date: date)
        return noteDetailTitleCell
      }
      
      if case let .content(content) = item {
        let noteDetailTextContentCell = tableView.dequeue(NoteDetailTextContentCell.self, indexPath: indexPath)
        noteDetailTextContentCell.configure(content: content)
        return noteDetailTextContentCell
      }
      
      return UITableViewCell()
    case .image:
      return UITableViewCell()
    case .link:
      return UITableViewCell()
    case .stock:
      return UITableViewCell()
    }
  })
  
  // MARK: UI Properties
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.alwaysBounceHorizontal = false
    $0.allowsSelection = false
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.register(UITableViewCell.self)
    $0.register(NoteStickerCell.self)
    $0.register(NoteDetailTitleCell.self)
    $0.register(NoteDetailTextContentCell.self)
  }
  
  private let moreDetailButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .moreButton)
  }

  // MARK: Initializing

  init(reactor: NoteDetailReactor) {
    super.init()
    self.reactor = reactor
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  override func configureUI() {
    super.configureUI()
    self.view.addSubviews(tableView)
    navigationItem.rightBarButtonItems = [moreDetailButton]
    bindUI()
  }

  override func configureConstraints() {
    super.configureConstraints()
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }


  // MARK: Bind

  override func bind(reactor: NoteDetailReactor) {

    // Action
    self.rx.viewDidLoad
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Void> in
        guard let self = self else {
          return Observable<Void>.empty()
        }
        return self.configureBackBarButtonItemIfNeeded()
      }
      .map { NoteDetailReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    Observable<Void>.just(())
      .map { NoteDetailReactor.Action.loadData }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.sectionModel }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  private func bindUI() {
    moreDetailButton.rx.tap.asDriver()
      .drive { [weak self] _ in
        guard let self = self else { return }
        let actionSheet = UIAlertController(
          title: nil,
          message: nil,
          preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(
          UIAlertAction(
            title: "노트 삭제",
            style: .destructive,
            handler: nil
          )
        )
        
        actionSheet.addAction(
          UIAlertAction(
            title: "노트 수정",
            style: .default,
            handler: nil
          )
        )
        
        actionSheet.addAction(
          UIAlertAction(
            title: "취소",
            style: .cancel,
            handler: nil
          )
        )
        self.present(actionSheet, animated: true, completion: nil)
    }
    .disposed(by: disposeBag)

  }
  
}
