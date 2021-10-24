//
//  NoteImageItemCell.swift
//  Tooda
//
//  Created by lyine on 2021/05/24.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit

import SnapKit

class NoteImageItemCell: BaseCollectionViewCell, View {
  typealias Reactor = NoteImageItemCellReactor
  
  var disposeBag: DisposeBag = DisposeBag()
  
  // TODO: ImageView로 변경 예정
  
  let containerView = UIImageView().then {
    $0.layer.cornerRadius = 8.0
    $0.layer.masksToBounds = true
    $0.contentMode = .scaleAspectFill
  }
  
  func configure(reactor: Reactor) {
    super.configure()
    self.reactor = reactor
  }
    
  func bind(reactor: Reactor) {
    reactor.state
      .map { $0.item }
      .asDriver(onErrorJustReturn: .init())
      .drive(onNext: { [weak self] in
        self?.fetchImage(urlString: $0.imageURL)
      }).disposed(by: self.disposeBag)
  }
  
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
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - Extension

extension NoteImageItemCell {
  private func fetchImage(urlString: String) {
    guard let image = urlString.urlImage else { return }
    self.containerView.image = image
  }
}

private extension String {
  var urlImage: UIImage? {
    guard let url = URL(string: self),
          let data = try? Data(contentsOf: url),
          let image = UIImage(data: data) else { return nil }
    
    return image
  }
}
