//
//  NoteDetailImageCell.swift
//  Tooda
//
//  Created by Lyine on 2022/02/01.
//

import UIKit
import SnapKit

final class NoteDetailImageCell: BaseTableViewCell {
  
  enum Metric {
    static let margin: CGFloat = 20.0
  }
  
  // MARK: - UI Properties
  
  private let imageContainerView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = UIColor.gray6
    $0.clipsToBounds = true
  }
  
  private let indicatorView = UIActivityIndicatorView()
  
  override func configureUI() {
    super.configureUI()
    
    contentView.addSubviews(
      imageContainerView,
      indicatorView
    )
  }
  
  func configure(data: Data) {
    super.configure()
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    imageContainerView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Metric.margin)
      $0.leading.trailing.equalToSuperview().inset(Metric.margin)
      $0.bottom.equalToSuperview()
    }
    
    indicatorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
