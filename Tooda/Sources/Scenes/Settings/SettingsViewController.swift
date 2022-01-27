//
//  SettingsViewController.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/05.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources
import SafariServices

final class SettingsViewController: BaseViewController<SettingsReactor> {
  
  // MARK: - Constants
  
  typealias Section = RxTableViewSectionedReloadDataSource<SettingsSectionModel>
  
  private enum Font {
    static let title = TextStyle.subTitle(color: .gray1)
  }
  
  // MARK: - Con(De)structor
  
  init(reactor: SettingsReactor) {
    super.init()
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Properties
  
  lazy var dataSource: Section = Section(configureCell: { section, tableView, indexPath, item -> UITableViewCell in
    guard let sectionType = section.sectionModels[safe: indexPath.section]?.identity else {
      return UITableViewCell()
    }
    switch sectionType {
    case .notification:
      let interactiveCell = tableView.dequeue(SettingsInteractiveCell.self, indexPath: indexPath)
      if case let .interactive(info) = item {
        interactiveCell.configure(
          with: SettingsInteractiveCell.Config(
            title: info.title,
            description: info.description,
            isOn: info.isOn
          )
        )
      }
      
      return interactiveCell
    case .appInfo, .account:
      let infoCell = tableView.dequeue(SettingsInfoCell.self, indexPath: indexPath)
      if case let .plain(info) = item {
        infoCell.configure(with: info.title)
      }
      return infoCell
    }
  })
  
  // MARK: - UI Components
  
  private lazy var titleLabel = UILabel().then {
    $0.attributedText = "앱 설정".styled(with: Font.title)
  }
  
  private let tableFooterView: UITableViewCell = SettingsTableFooterView().then {
    $0.frame = CGRect(
      origin: CGPoint.zero,
      size: CGSize(width: UIScreen.main.bounds.width, height: 50)
    )
  }
  
  private lazy var tableView = UITableView().then {
    $0.backgroundColor = .gray5
    $0.register(UITableViewCell.self)
    $0.register(SettingsHeaderView.self)
    $0.register(SettingsInfoCell.self)
    $0.register(SettingsInteractiveCell.self)
    $0.register(SettingsSectionFooterView.self)
    $0.register(SettingsTableFooterView.self)
    $0.delegate = self
    $0.separatorStyle = .none
    $0.tableFooterView = tableFooterView
  }
  
  // MARK: - Overridden: ParentClass
  
  override func bind(reactor: SettingsReactor) {
    
    rx.viewDidLoad
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Void> in
        return self?.configureBackBarButtonItemIfNeeded() ?? .empty() }
      .map { SettingsReactor.Action.didTapbackbutton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.sectionModel }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
    
    let sharedItemSelected = tableView.rx.itemSelected.share()
    
    sharedItemSelected
      .filter { $0.section != SettingsSectionModel.SectionType.appInfo.rawValue }
      .map { SettingsReactor.Action.didTapPlainSettingItem(index: $0.item) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    sharedItemSelected
      .filter { $0.section != SettingsSectionModel.SectionType.account.rawValue }
      .map { SettingsSectionModel.SectionType.AccountUserAction(rawValue: $0.item) }
      .compactMap { $0 }
      .flatMap { [weak self] action -> Observable<SettingsSectionModel.SectionType.AccountUserAction> in
        guard let self = self else { return .empty() }
        let actions = [
          UIAlertController.AlertAction(
            title: "확인",
            style: .default
          ),
          UIAlertController.AlertAction(
            title: "취소",
            style: .cancel
          )
        ]
        return UIAlertController.present(
          in: self,
          title: action.alertTitle,
          message: nil,
          style: .alert,
          actions: actions
        )
        .filter { $0 == 0 }
        .flatMap { _ in Observable<SettingsSectionModel.SectionType.AccountUserAction>.just(action)
        }
      }
      .map { SettingsReactor.Action.didTapAcountSettingItem(action: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
    navigationItem.titleView = titleLabel
    navigationController?.navigationBar.backItem?.title = ""
    view.addSubview(tableView)
  }

  override func configureConstraints() {
    super.configureConstraints()
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

extension SettingsViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    guard let sectionType = dataSource.sectionModels[safe: indexPath.section]?.identity else {
      return CGFloat.zero
    }
    
    return sectionType.cellHeight
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return 50
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let title = dataSource.sectionModels[safe: section]?.identity.title else {
      return nil
    }
    
    let header = tableView.dequeue(SettingsHeaderView.self)
    header.configure(with: title)
    return header
  }
  
  func tableView(
    _ tableView: UITableView,
    viewForFooterInSection section: Int
  ) -> UIView? {
    guard let type = dataSource.sectionModels[safe: section]?.identity else {
      return nil
    }
    
    let footer = tableView.dequeue(SettingsSectionFooterView.self)
    footer.configure(title: type.footerTitle)
    
    switch type {
    case .appInfo:
      return footer
    default:
      return nil
    }
  }
  
  func tableView(
    _ tableView: UITableView,
    heightForFooterInSection section: Int
  ) -> CGFloat {
    guard let type = dataSource.sectionModels[safe: section]?.identity else {
      return 0
    }
    switch type {
    case .notification:
      return 21
    case .appInfo:
      return 63
    case .account:
      return 0
    }
  }
}
