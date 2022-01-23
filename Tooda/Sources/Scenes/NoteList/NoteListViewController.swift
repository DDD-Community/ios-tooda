//
//  NoteListViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/28.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources

final class NoteListViewController: BaseViewController<NoteListReactor> {
  
  // MARK: - Constants
  
  typealias Section = RxTableViewSectionedAnimatedDataSource<NoteListModel>
  
  private enum Font {
    static let title = TextStyle.subTitle(color: .gray1)
    static let description = TextStyle.body(color: .gray2)
  }
  
  // MARK: Properties
  
  lazy var dataSource: Section = Section(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
    let cell = tableView.dequeue(NoteListCell.self, indexPath: indexPath)
    cell.configure(with: item)
    return cell
  })
  
  // MARK: - UI Components
  
  private lazy var titleLabel = UILabel()
  
  private let searchBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .searchBarButton)
  }
  
  private let moreDetailButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .moreButton)
  }
  
  private let emptyDefaultView = UIView().then {
    $0.backgroundColor = .gray5
  }
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = .gray5
    $0.register(UITableViewCell.self)
    $0.register(NoteListCell.self)
    $0.separatorStyle = .none
    $0.delegate = self
  }
  
  private let dismissBarButton = UIBarButtonItem(
    image: UIImage(type: .closeButton)?.withRenderingMode(.alwaysOriginal),
    style: .plain,
    target: nil,
    action: nil
  )
  
  private let addNoteButton = UIButton(type: .system).then {
    $0.configureShadow(
      color: UIColor.black.withAlphaComponent(0.2),
      x: 0,
      y: 8,
      blur: 56,
      spread: 0
    )
    $0.setImage(UIImage(type: .addNewNoteButton)?.withRenderingMode(.alwaysOriginal), for: .normal)
  }
  
  // MARK: - Con(De)structor
  
  init(reactor: NoteListReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    UIApplication.shared.statusBarUIView?.backgroundColor = .clear
  }
  
  // MARK: - Overridden: ParentClass
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindUI()
  }
  
  override func bind(reactor: NoteListReactor) {
    rx.viewWillAppear.take(1)
      .map { _ in NoteListReactor.Action.initialLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    addNoteButton.rx.tap
      .map { _ in NoteListReactor.Action.dismiss }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    dismissBarButton.rx.tap
      .map { _ in NoteListReactor.Action.dismiss }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tableView.rx.willDisplayCell
      .map { NoteListReactor.Action.pagnationLoad(willDisplayIndex: $0.indexPath.row) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.noteListModel }
      .bind(to: tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isEmpty }
      .compactMap { $0 }
      .asDriver(onErrorJustReturn: false)
      .drive { [weak self] isEmpty in
        guard let self = self else { return }
        if isEmpty {
          self.view.insertSubview(
            self.emptyDefaultView,
            belowSubview: self.addNoteButton
          )
        } else {
          self.view.insertSubview(
            self.tableView,
            belowSubview: self.addNoteButton
          )
        }
      }
      .disposed(by: disposeBag)
    
    tableView.rx.setDelegate(self)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.dateInfo }
      .asDriver(onErrorJustReturn: (year: Date().year, month: Date().month))
      .drive { [weak self] dateInfo in
        guard let self = self else { return }
        self.setNavigationTitle(year: dateInfo.year, month: dateInfo.month)
      }
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
            title: "다이어리 삭제",
            style: .destructive,
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
  
  // MARK: - configureUI
  
  override func configureUI() {
    navigationItem.leftBarButtonItem = dismissBarButton
    navigationItem.rightBarButtonItems = [
      moreDetailButton,
      searchBarButton
    ]
    navigationController?.navigationBar.backgroundColor = .white
    UIApplication.shared.statusBarUIView?.backgroundColor = .white
    view.addSubviews(
      emptyDefaultView,
      tableView,
      addNoteButton
    )
  }
  
  override func configureConstraints() {
    super.configureConstraints()
    
    emptyDefaultView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addNoteButton.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(6)
      $0.width.height.equalTo(108)
    }
    
    setupEmptyBackgroundView()
  }
  
  // MARK: Private
  
  private func setNavigationTitle(year: Int, month: Int) {
    titleLabel.text = "\(year)년 \(month)월"
    navigationItem.titleView = titleLabel
  }
  
  private func setupEmptyBackgroundView() {
    let imageView = UIImageView().then {
      $0.image = UIImage(type: .iconSmileEmoji)
    }
    
    let descriptionLabel = UILabel().then {
      $0.attributedText = "새로운 투자기록을\n작성해보세요!"
                            .styled(with: Font.description)
                            .alignment(with: .center)
      $0.numberOfLines = 0
    }
    
    emptyDefaultView.addSubviews(
      imageView,
      descriptionLabel
    )
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(307)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(36)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(20)
      $0.centerX.equalToSuperview()
    }
  }
}

// MARK: - UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return UITableView.automaticDimension
  }
}
