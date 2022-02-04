//
//  ImagePlaceHolderView.swift
//  Tooda
//
//  Created by Lyine on 2022/02/01.
//

import UIKit

final class ImagePlaceHolderView: UIView {
  
  // MARK: - UI Properties
  
  let containerView = UIView().then {
    $0.backgroundColor = UIColor.gray5
    $0.layer.cornerRadius = 8.0
    $0.layer.masksToBounds = true
  }
  
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  init(frame: CGRect = .zero, image: UIImage?) {
    super.init(frame: frame)
    self.configureUI(image: image)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUI(image: UIImage?) {
    
    [containerView].forEach {
      self.addSubview($0)
    }
    
    containerView.addSubviews(imageView)
    
    self.imageView.image = image
    
    self.setupConstraints()
  }
  
  func setupConstraints() {
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    imageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(CGSize(width: 18.72, height: 18.75))
    }
  }
}
