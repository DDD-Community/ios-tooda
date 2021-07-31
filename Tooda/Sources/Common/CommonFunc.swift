//
//  CommonFunc.swift
//  Toda
//
//  Created by lyine on 2021/04/07.
//  Copyright © 2021 DTS. All rights reserved.
//

import Foundation
import UIKit

func appName() -> String {
  guard let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String else { return "" }
  return name
}

func appBundleID() -> String {
  guard let name = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else { return "" }
  return name
}

func baseUrl() -> String {
  "http://15.164.46.210:3000/"
}

func deviceUUID() -> String? {
  UIDevice.current.identifierForVendor?.uuidString
}
