//
//  HomeViewController.swift
//  Tooda
//
//  Created by jinsu on 2021/05/20.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import Then
import SnapKit

final class HomeViewController: BaseViewController<HomeReactor> {

  // MARK: Constants

  private enum Font {
    static let monthTitle = TextStyle.headlineBold(color: .gray1)
    static let noteCount = TextStyle.bodyBold(color: .gray2)
    static let noteCountSuffix = TextStyle.body(color: .gray2)
  }

  private enum Metric {
    static let notebookCellSize = CGSize(
      width: ceil(230.0 / 375.0 * UIScreen.main.bounds.size.width),
      height: ceil(323.0 / 812.0 * UIScreen.main.bounds.size.height)
    )
  }

  private enum Const {
    static let notebookCellIdentifier = NotebookCell.description()
  }


  // MARK: UI

  private let searchBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .searchBarButton)
  }
  
  private let settingBarButton = UIBarButtonItem().then {
    $0.image = UIImage(type: .settingBarButton)
  }

  private let monthTitleButton = UIButton().then {
    $0.semanticContentAttribute = .forceRightToLeft
    $0.setImage(
      UIImage(type: .iconDownGray),
      for: .normal
    )
    $0.setAttributedTitle("wrewr".styled(with: Font.monthTitle), for: .normal)
  }

  private let noteCountLabel = UILabel().then {
    $0.numberOfLines = 1
    $0.attributedText = "3".styled(with: Font.noteCount) + "werwerwe".styled(with: Font.noteCountSuffix)
  }

  private let notebookCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 30.0
      $0.minimumInteritemSpacing = 0.0
      $0.sectionInset = .init(horizontal: 72.0)
    }
  ).then {
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    $0.register(NotebookCell.self, forCellWithReuseIdentifier: Const.notebookCellIdentifier)
  }


  // MARK: Initializing

  init(reactor: HomeReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = nil
    self.view.backgroundColor = .white
  }


  // MARK: Bind

  override func bind(reactor: HomeReactor) {
    self.notebookCollectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

    // Action
    Observable<Void>.just(())
      .map { HomeReactor.Action.load }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    self.reactor?.state
      .map { $0.notebooks }
      .bind(to: self.notebookCollectionView.rx.items(
        cellIdentifier: Const.notebookCellIdentifier,
        cellType: NotebookCell.self
      )) { _, notebook, cell in
        cell.configure(viewModel: notebook)
      }.disposed(by: self.disposeBag)
  }
  
  override func configureUI() {
    self.navigationItem.rightBarButtonItems = [
      self.settingBarButton,
      self.searchBarButton
    ]

    self.view.do {
      $0.addSubview(self.monthTitleButton)
      $0.addSubview(self.noteCountLabel)
      $0.addSubview(self.notebookCollectionView)
    }
  }

  override func configureConstraints() {
    self.monthTitleButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(57.0)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(CGSize(width: 136.0, height: 39.0))
    }

    self.noteCountLabel.snp.makeConstraints {
      $0.top.equalTo(self.monthTitleButton.snp.bottom).offset(5.0)
      $0.centerX.equalToSuperview()
    }

    self.notebookCollectionView.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.right.equalToSuperview()
      $0.top.equalTo(self.noteCountLabel.snp.bottom).offset(35.0)
      $0.height.equalTo(Metric.notebookCellSize.height)
    }
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return Metric.notebookCellSize
  }
}
