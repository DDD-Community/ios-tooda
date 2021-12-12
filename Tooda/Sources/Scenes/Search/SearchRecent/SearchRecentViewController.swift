//
//  SearchRecentViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/11/14.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

final class SearchRecentViewController: BaseViewController<SearchRecentReactor> {

  // MARK: UI

  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.minimumLineSpacing = 16.0
    }
  ).then {
    $0.backgroundColor = . clear
    $0.contentInset = .init(bottom: 24.0)
    $0.showsHorizontalScrollIndicator = false
    $0.alwaysBounceVertical = true
    $0.register(SearchRecentTitleCell.self)
    $0.register(SearchRecentKeywordCell.self)
  }


  // MARK: Properties

  private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SearchRecentSectionModel>(
    configureCell: { [weak self] section, collectionView, indexPath, item -> UICollectionViewCell in
      guard let self = self,
            let section = section.sectionModels[safe: indexPath.section]?.identity else {
        return .init()
      }

      switch section {
      case .header:
        let header = collectionView.dequeue(
          SearchRecentTitleCell.self,
          indexPath: indexPath
        )
        return header

      case .keyword:
        guard case let .keyword(viewModel) = item else { return .init() }
        let cell = collectionView.dequeue(
          SearchRecentKeywordCell.self,
          indexPath: indexPath
        )

        cell.delegate = self
        cell.configure(viewModel: viewModel)
        return cell
      }
    })


  // MARK: Custom Action

  let rxBeginSearch = PublishRelay<Void>()
  let rxSearch = PublishRelay<String>()

  private let rxRemoveKeyword = PublishRelay<Int>()


  // MARK: Initialzing

  init(reactor: SearchRecentReactor) {
    super.init()
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
  }


  // MARK: Bind

  override func bind(reactor: SearchRecentReactor) {
    self.collectionView.rx
      .setDelegate(self)
      .disposed(by: self.disposeBag)

    // Action

    self.rxBeginSearch
      .asObservable()
      .map { SearchRecentReactor.Action.beginSearch }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxSearch
      .asObservable()
      .map { SearchRecentReactor.Action.search(text: $0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxRemoveKeyword
      .asObservable()
      .map { SearchRecentReactor.Action.remove(index: $0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State

    reactor.state
      .map { $0.keywords }
      .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)
  }

  override func configureUI() {
    self.view.do {
      $0.addSubview(self.collectionView)
    }
  }

  override func configureConstraints() {
    self.collectionView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
      $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
      $0.left.equalTo(self.view.safeAreaLayoutGuide.snp.left).inset(20.0)
      $0.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).inset(20.0)
    }
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension SearchRecentViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    guard let section = self.dataSource.sectionModels[safe: indexPath.section]?.identity else { return .zero }

    return CGSize(
      width: collectionView.frame.width,
      height: section.cellHeight
    )
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    guard let section = self.dataSource.sectionModels[safe: section]?.identity else { return .zero }

    return section.edgeInsets
  }
}


// MARK: SearchRecentKeywordCellDelegate

extension SearchRecentViewController: SearchRecentKeywordCellDelegate {

  func didTapRemove(_ sender: SearchRecentKeywordCell) {
    guard let index = sender.viewModel?.index else { return }

    self.rxRemoveKeyword.accept(index)
  }
}
