//
//  OptionsPopUpView.swift
//  Tooda
//
//  Created by 황재욱 on 2021/12/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxDataSources
import RxSwift
import RxCocoa

final class OptionsPopUpView: BasePopUpView {
  
  // MARK: - Constants
  
  typealias Section = RxTableViewSectionedReloadDataSource<EmojiOptionsSectionModel>
  
  // MARK: - RxStream
  
  lazy var didSelectOptionStream = tableView.rx.itemSelected
  
  // MARK: - Properties
  
  private let dataSource = Section { _, tableView, indexPath, item in
    let cell = tableView.dequeue(
      OneLineReviewOptionCell.self,
      indexPath: indexPath
    )
    cell.configure(sticker: item)
    return cell
  }
  
  // MARK: - UI Components
  
  private let tableView = SelfSizingTableView().then {
    $0.rowHeight = UITableView.automaticDimension
    $0.register(OneLineReviewOptionCell.self)
    $0.separatorStyle = .none
  }
  
  // MARK: - Overridden: ParentClass
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupUI() {
    super.setupUI()
    insertContentViewLayout(
      view: tableView,
      margin: UIEdgeInsets(top: 18, left: 0, bottom: 26, right: 0)
    )
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.reloadData()
    tableView.invalidateIntrinsicContentSize()
  }
  
  // MARK: - Internal methods
  
  func bindDataSource(sectionModel: Observable<[EmojiOptionsSectionModel]>) {
    
    sectionModel
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
