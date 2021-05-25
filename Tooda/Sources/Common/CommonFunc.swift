//
//  CommonFunc.swift
//  Toda
//
//  Created by lyine on 2021/04/07.
//  Copyright © 2021 DTS. All rights reserved.
//

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
	guard let url = Bundle.main.infoDictionary?["APP_SERVER_URL"] as? String else { return "" }
	return url
}

func openURL(url: URL) {
  UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
