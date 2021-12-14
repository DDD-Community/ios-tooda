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
import RxCocoa
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
    static let notebookContentInset: UIEdgeInsets = .init(horizontal: 72.0)
  }

  private enum Const {
    static let notebookCellIdentifier = NotebookCell.description()
  }

  private enum Text {
    static let noteCount = "{count}개의 기록이 있어요"
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
  }

  private let noteCountLabel = UILabel().then {
    $0.numberOfLines = 1
  }

  private let notebookCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 30.0
      $0.minimumInteritemSpacing = 0.0
    }
  ).then {
    $0.backgroundColor = .clear
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    $0.contentInset = Metric.notebookContentInset
    $0.register(NotebookCell.self, forCellWithReuseIdentifier: Const.notebookCellIdentifier)
  }
  
  private let noteGuideView = CreateNoteGuideView(frame: .zero)


  // MARK: Custom Action

  private let rxScrollToItem = BehaviorRelay<Int>(value: 0)
  private let rxPickDate = PublishRelay<Date>()
  private let rxNoteGuideViewTap = PublishRelay<Void>()

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

    self.rxScrollToItem
      .asObservable()
      .map { HomeReactor.Action.paging(index: $0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.rxPickDate
      .asObservable()
      .map { HomeReactor.Action.pickDate($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.rxNoteGuideViewTap
      .asObservable()
      .map { HomeReactor.Action.presentCreateNote }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    self.searchBarButton.rx.tap
      .map { HomeReactor.Action.pushSearch }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    settingBarButton.rx.tap
      .map { HomeReactor.Action.pushSettings }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    // State
    self.reactor?.state
      .map { $0.notebookViewModels }
      .bind(to: self.notebookCollectionView.rx.items(
        cellIdentifier: Const.notebookCellIdentifier,
        cellType: NotebookCell.self
      )) { _, notebook, cell in
        cell.configure(viewModel: notebook)
      }.disposed(by: self.disposeBag)

    reactor.state
      .filter { $0.selectedNotobook != nil }
      .map { $0.selectedNotobook! }
      .subscribe(onNext: { [weak self] notebook in
        self?.monthTitleButton.setAttributedTitle(
          Date(year: notebook.year, month: notebook.month, day: 1)
            .string(.dotMonth)
            .styled(with: Font.monthTitle),
          for: .normal
        )
        self?.noteCountLabel.attributedText = Text.noteCount
          .styled(with: Font.noteCountSuffix)
          .replace(key: "count", value: "\(notebook.noteCount)", style: Font.noteCount)
      }).disposed(by: self.disposeBag)

    reactor.state
      .filter { $0.selectedIndex != nil }
      .map { $0.selectedIndex! }
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] index in
        self?.notebookCollectionView.scrollToItem(
          at: .init(item: index, section: 0),
          at: .centeredHorizontally,
          animated: true
        )
      }).disposed(by: self.disposeBag)
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
      $0.addSubview(self.noteGuideView)
    }

    self.monthTitleButton.addTarget(
      self,
      action: #selector(didTapMonthTitle),
      for: .touchUpInside
    )
    
    self.noteGuideView.delegate = self
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
    
    self.noteGuideView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}


// MARK: Internal

extension HomeViewController {

  private func presentDatePickerAlert(onConfirm: @escaping (Date) -> Void) {
    let datePicker = JSDatePicker()

    let alertController = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .actionSheet
    ).then {
      $0.view.addSubview(datePicker)
      $0.addAction(.init(title: "확인", style: .default, handler: { _ in
        onConfirm(datePicker.selectedDate)
      }))
      $0.addAction(.init(title: "취소", style: .cancel, handler: nil))
    }

    datePicker.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(110.0)
    }

    self.present(alertController, animated: true)
  }

  @objc private func didTapMonthTitle() {
    self.presentDatePickerAlert(onConfirm: { [weak self] date in
      self?.rxPickDate.accept(date)
    })
  }
}


// MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return Metric.notebookCellSize
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    targetContentOffset.pointee = scrollView.contentOffset

    let maxCount = self.notebookCollectionView.numberOfItems(inSection: 0) - 1
    let estimatedIndex = (scrollView.contentOffset.x + Metric.notebookContentInset.left) / Metric.notebookCellSize.width
    let index: Int = {
      if velocity.x > 0 {
        return min(maxCount, Int(ceil(estimatedIndex)))
      } else if velocity.x < 0 {
        return max(0, Int(floor(estimatedIndex)))
      } else {
        let index = Int(round(estimatedIndex))
        return index < 0 ? 0 : min(maxCount, index)
      }
    }()

    self.rxScrollToItem.accept(index)
    self.notebookCollectionView.scrollToItem(
      at: .init(item: index, section: 0),
      at: .centeredHorizontally,
      animated: true
    )
  }
}

// MARK: - CreateNoteGuideViewDelegate

extension HomeViewController: CreateNoteGuideViewDelegate {
  func contentDidTapped() {
    self.rxNoteGuideViewTap.accept(())
  }
}
