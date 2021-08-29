//
//  NoteImageCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import SnapKit

class NoteImageCell: BaseTableViewCell, View {
  typealias Reactor = NoteImageCellReactor
  typealias Section = RxCollectionViewSectionedReloadDataSource<NoteImageSection>
  
  private enum Constants {
    static let baseItemValue: CGFloat = 94
  }

  var disposeBag: DisposeBag = DisposeBag()
  
  lazy var dataSource: Section = Section(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
    switch item {
      case .empty(let reactor):
        let cell = collectionView.dequeue(EmptyNoteImageItemCell.self, indexPath: indexPath)
        cell.configure(reactor: reactor)
        return cell
      case .item(let reactor):
        let cell = collectionView.dequeue(NoteImageItemCell.self, indexPath: indexPath)
        cell.configure(reactor: reactor)
        return cell
    }
  })
  
  let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
  
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout).then {
    $0.backgroundColor = .white
    self.flowLayout.scrollDirection = .horizontal
    self.flowLayout.minimumLineSpacing = 10
    self.flowLayout.minimumInteritemSpacing = 10
    self.flowLayout.sectionHeadersPinToVisibleBounds = true
    
    $0.alwaysBounceVertical = false
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    
    // cell
    $0.register(EmptyNoteImageItemCell.self)
    $0.register(NoteImageItemCell.self)
    
    self.flowLayout.itemSize = CGSize(width: Constants.baseItemValue, height: Constants.baseItemValue)
  }
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
  
  override func configureUI() {
    super.configureUI()
    
    [collectionView].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(Constants.baseItemValue)
    }
  }

  func bind(reactor: Reactor) {
    
    Observable.just(())
      .map { _ in Reactor.Action.initiailizeSection }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    collectionView.rx.itemSelected
      .map { Reactor.Action.didSelectedItem($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.sections }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.requestPermissionMessage }
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] in
        self?.showAlertAndOpenAppSetting(message: $0)
      })
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.showAlertMessage }
      .filter { $0 != nil }
      .subscribe(onNext: { [weak self] in
        self?.showAlert(message: $0)
      })
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
  }
}

// MARK: UICollectionViewDelegate

extension NoteImageCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 0, right: 10)
  }
}

extension NoteImageCell {
  func showAlert(message: String?) {
    print(message)
  }
  
  func showAlertAndOpenAppSetting(message: String?) {
    print(message)
  }
  
  private func openAppSettingMenu() {
    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
