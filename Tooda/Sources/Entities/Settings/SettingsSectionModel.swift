//
//  SettingsSectionModel.swift
//  Tooda
//
//  Created by 황재욱 on 2021/09/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import RxDataSources

struct SettingsSectionModel {
  enum SectionType: Int {
    case notification
    case etc
    
    var title: String {
      switch self {
      case .notification:
        return "알림 설정"
      case .etc:
        return "기타"
      }
    }
    
    var footerTitle: String? {
      switch self {
      case .notification:
        return nil
      case .etc:
        return "현재 버전 1.0.0"
      }
    }
  }
  let identity: SectionType
  var items: [SettingsItem]
}

extension SettingsSectionModel: SectionModelType {
  init(
    original: SettingsSectionModel,
    items: [SettingsItem]
  ) {
    self = .init(
      identity: original.identity,
      items: items
    )
  }
}

enum SettingsItem {
  case interactive(InteractiveSettingsInfo)
  case plain(PlainSettingsInfo)
}
