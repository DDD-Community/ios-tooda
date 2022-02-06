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
  
  lazy var dataSource: Section = Section(configureCell: { [weak self] section, tableView, indexPath, item -> UITableViewCell in
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
      
      if case let .image(data) = item {
        let cell = tableView.dequeue(NoteDetailImageCell.self, indexPath: indexPath)
        cell.configure(data: data)
        return cell
      }
      
      return UITableViewCell()
    case .link:
        if case let .link(reactor) = item {
          let cell = tableView.dequeue(NoteLinkCell.self, indexPath: indexPath)
          cell.configure(reactor: reactor)
          
          cell.rx.itemDidTapped
            .subscribe(onNext: { [weak self] in
              self?.linkItemCellDidTappedRelay.accept($0)
            })
            .disposed(by: cell.disposeBag)
          
          return cell
        }
        
        return UITableViewCell()
    case .stock:
      if case let .stock(reactor) = item {
        let cell = tableView.dequeue(NoteStockCell.self, indexPath: indexPath)
        cell.configure(with: reactor)
        return cell
      }
      
      return UITableViewCell()
    }
  })
  
  private let deleteNoteButtonRelay: PublishRelay<Void> = PublishRelay()
  private let editNoteButtonRelay: PublishRelay<Void> = PublishRelay()
  
  private let linkItemCellDidTappedRelay: PublishRelay<String> = PublishRelay()
  
  // MARK: UI Properties
  
  private let tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.alwaysBounceHorizontal = false
    $0.allowsSelection = false
    $0.register(UITableViewCell.self)
    $0.register(NoteStickerCell.self)
    $0.register(NoteDetailTitleCell.self)
    $0.register(NoteDetailTextContentCell.self)
    $0.register(NoteStockCell.self)
    $0.register(NoteLinkCell.self)
    $0.register(NoteDetailImageCell.self)
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
    
    self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)

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
    
    self.editNoteButtonRelay
      .map { NoteDetailReactor.Action.editNote }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.deleteNoteButtonRelay
      .map { NoteDetailReactor.Action.deleteNote }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.linkItemCellDidTappedRelay
      .map { NoteDetailReactor.Action.linkItemDidTapped($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .observe(on: MainScheduler.asyncInstance)
      .map { $0.sectionModel }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.snackbarInfo }
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: { snackbarInfo in
        guard let snackbarInfo = snackbarInfo else { return }
        SnackBarManager.shared.display(info: snackbarInfo)
      }).disposed(by: self.disposeBag)
  }
  
  private func bindUI() {
    rx.viewWillAppear
      .asDriver(onErrorJustReturn: true)
      .drive { [weak self] _ in
        guard let navigationBar = self?
                .navigationController?
                .navigationBar else { return }
        
        AppApppearance.updateNavigaionBarAppearance(navigationBar, with: .white)
      }
      .disposed(by: disposeBag)
    
    rx.viewWillDisappear
      .asDriver(onErrorJustReturn: true)
      .drive { [weak self] _ in
        guard let navigationBar = self?
                .navigationController?
                .navigationBar else { return }
        
        AppApppearance.updateNavigaionBarAppearance(navigationBar, with: .clear)
        
      }
      .disposed(by: disposeBag)
    
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
            handler: { [weak self] _ in
              self?.deleteActionSheetDidTapped()
            }
          )
        )
        
        actionSheet.addAction(
          UIAlertAction(
            title: "노트 수정",
            style: .default,
            handler: { [weak self] _ in
              self?.editNoteButtonRelay.accept(())
            }
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
  
  private func deleteActionSheetDidTapped() {
    let alertController = UIAlertController(title: "정말 삭제할까요?",
                                            message: "한 번 삭제하면 되돌릴 수 없어요.",
                                            preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
      self?.deleteNoteButtonRelay.accept(())
    })
    
    let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
    
    alertController.addAction(cancel)
    alertController.addAction(ok)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
}

// MARK: - Extensions

extension NoteDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch dataSource[indexPath] {
      case .title, .content, .link, .sticker, .stock:
        return UITableView.automaticDimension
      case .image(let data):
        guard let image = UIImage(data: data) else { return UITableView.automaticDimension }
        
        let resizedImage = image.resizeImage(width: tableView.frame.width - NoteDetailImageCell.Metric.margin - NoteDetailImageCell.Metric.margin)
        
        return NoteDetailImageCell.Metric.margin + resizedImage.size.height
    }
  }
}
