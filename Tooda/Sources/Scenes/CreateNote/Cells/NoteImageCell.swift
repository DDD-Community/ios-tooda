//
//  NoteImageCell.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit
import ReactorKit
import RxCocoa
import RxDataSources
import SnapKit

class NoteImageCell: BaseTableViewCell, View {
  typealias Reactor = NoteImageCellReactor
  typealias Section = RxCollectionViewSectionedReloadDataSource<NoteImageSection>
  
  private enum Constants {
    static let baseItemValue: CGFloat = 74
  }

  var disposeBag: DisposeBag = DisposeBag()
  
  let cellItemDidTapRelay: PublishRelay<IndexPath> = PublishRelay()
  
  private lazy var dataSource: Section = Section(configureCell: { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
    switch item {
      case .empty(let reactor):
        let cell = collectionView.dequeue(EmptyNoteImageItemCell.self, indexPath: indexPath)
        cell.configure(reactor: reactor)
        
        if let relay = self?.cellItemDidTapRelay {
          cell.rx.addImageButtonDidTap
            .bind(to: relay)
            .disposed(by: cell.disposeBag)
        }
        
        return cell
      case .item(let reactor):
        let cell = collectionView.dequeue(NoteImageItemCell.self, indexPath: indexPath)
        cell.configure(reactor: reactor)
        
        if let relay = self?.cellItemDidTapRelay {
          cell.rx.deleteButtonDidTap
            .bind(to: relay)
            .disposed(by: cell.disposeBag)
        }
        
        return cell
    }
  })
  
  private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
  
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
  
  // MARK: Cell Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
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
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
      $0.height.equalTo(Constants.baseItemValue)
    }
  }

  func bind(reactor: Reactor) {
    
    Observable.just(())
      .map { _ in Reactor.Action.fetchSections }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.sections }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
  }
}

// MARK: UICollectionViewDelegate

// TODO: Master 병합 후 Extension 변경 처리
extension NoteImageCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 0, left: 0, bottom: 0, right: 10)
  }
}

// MARK: Reactive Extensions

extension Reactive where Base: NoteImageCell {
  var didSelectedItemCell: Observable<IndexPath> {
    return self.base.cellItemDidTapRelay.asObservable()
  }
}
