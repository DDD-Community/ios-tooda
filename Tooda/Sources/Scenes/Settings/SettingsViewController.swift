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

final class SettingsViewController: BaseViewController<SettingsReactor> {
  
  typealias Section = RxTableViewSectionedReloadDataSource<SettingsSectionModel>
  
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
    case .etc:
      let infoCell = tableView.dequeue(SettingsInfoCell.self, indexPath: indexPath)
      if case let .plain(info) = item {
        infoCell.configure(with: info.title)
      }
      return infoCell
    }
  })
  
  // MARK: - UI Components
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func bind(reactor: SettingsReactor) {
    reactor.state
      .map { $0.sectionModel }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  // MARK: - configureUI
  
  override func configureUI() {
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
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let sectionType = dataSource.sectionModels[safe: indexPath.section]?.identity else {
      return CGFloat.zero
    }
    
    switch sectionType {
    case .notification:
      return 54
    case .etc:
      return 54
    }
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    50
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let title = dataSource.sectionModels[safe: section]?.identity.title else {
      return nil
    }
    let header = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsHeaderView.self)) as! SettingsHeaderView
    header.configure(with: title)
    return header
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let type = dataSource.sectionModels[safe: section]?.identity else {
      return nil
    }
    let footer = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingsSectionFooterView.self)) as! SettingsSectionFooterView
    switch type {
    case .notification:
      footer.configure(title: nil)
    case .etc:
      footer.configure(title: "현재 버전 1.0.0")
    }
    return footer
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    guard let type = dataSource.sectionModels[safe: section]?.identity else {
      return 0
    }
    switch type {
    case .notification:
      return 21
    case .etc:
      return 63
    }
  }
}
