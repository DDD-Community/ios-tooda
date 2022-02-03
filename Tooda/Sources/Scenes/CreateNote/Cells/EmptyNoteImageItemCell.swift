//
//  EmptyNoteImageItemCell.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit

import SnapKit
import RxCocoa

class EmptyNoteImageItemCell: BaseCollectionViewCell {
  var disposeBag: DisposeBag = DisposeBag()
  
  let containerView = UIView().then {
    $0.backgroundColor = UIColor(type: .gray3)
    $0.layer.cornerRadius = 8.0
    $0.layer.masksToBounds = true
  }
  
  let addImageButton = UIButton()
  
  // MARK: Cell Life Cycle
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  override func configureUI() {
    super.configureUI()
    
    [containerView].forEach {
      self.contentView.addSubview($0)
    }
    
    containerView.addSubviews(addImageButton)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    addImageButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - Extensions

extension Reactive where Base: EmptyNoteImageItemCell {
  var addImageButtonDidTap: Observable<IndexPath> {
    return self.base.addImageButton.rx.tap
      .flatMap { [weak base] _ -> Observable<IndexPath> in
        guard let indexPath = base?.indexPath else { return .empty() }
        return Observable.just(indexPath)
      }
  }
}
