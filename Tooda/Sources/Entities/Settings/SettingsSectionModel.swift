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
    case appInfo
    case account
    
    enum AccountUserAction: Int {
      case logOut
      case dropOut
      
      var alertTitle: String {
        switch self {
        case .logOut:
          return "로그아웃 하시겠습니까?"
        case .dropOut:
          return "탈퇴하시겠습니까?"
        }
      }
    }
    
    var title: String {
      switch self {
      case .notification:
        return "알림 설정"
      case .appInfo:
        return "앱 정보"
      case .account:
        return "계정"
      }
    }
    
    var footerTitle: String? {
      switch self {
      case .notification:
        return nil
      case .appInfo:
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
          return "현재 버전 \(appVersion)"
        } else {
          return nil
        }
      case .account:
        return nil
      }
    }
    
    var cellHeight: CGFloat {
      return 54
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
