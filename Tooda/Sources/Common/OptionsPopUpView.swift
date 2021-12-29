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
  
  // MARK: - Rx Stream
  
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
  
  private let tableView = SelfSizingTableView()
  
  // MARK: - Overridden: ParentClass

  override func setupUI() {
    super.setupUI()
    insertContentViewLayout(
      view: tableView,
      margin: UIEdgeInsets(top: 18, left: 0, bottom: 26, right: 0)
    )
  }
  
  // MARK: - Internal methods
  
  func registerCell(cellType: UITableViewCell.Type) {
    tableView.register(cellType)
  }
  
  func bindDataSource(sectionModel: Observable<[EmojiOptionsSectionModel]>) {
    sectionModel
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
