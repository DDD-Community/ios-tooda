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
  
	let placeHolderView = ImagePlaceHolderView(image: UIImage(type: .iconAddImagePlaceHolder)).then {
		$0.layer.borderColor = UIColor.gray4.cgColor
		$0.layer.borderWidth = 1.0
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
    
    [placeHolderView, addImageButton].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    placeHolderView.snp.makeConstraints {
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
