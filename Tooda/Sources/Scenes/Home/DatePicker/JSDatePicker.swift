//
//  JSDatePicker.swift
//  Tooda
//
//  Created by jinsu on 2021/10/04.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import Then
import SnapKit

final class JSDatePicker: UIView {

  // MARK: Constants

  private enum Const {
    static let years: [Int] = {
      var years: [Int] = []
      let current = Date().year
      let min = current - 10

      for year in min...current {
        years.append(year)
      }
      return years
    }()
    static let months: [Int] = {
      var months: [Int] = []
      for month in 1...12 {
        months.append(month)
      }
      return months
    }()
  }


  // MARK: UI

  private let pickerView = UIPickerView()


  // MARK: Component

  enum DateComponentType: Int {
    case year = 0
    case month = 1
  }


  // MARK: Properties

  var selectedDate: Date {
    let currentDate = Date()

    let year = Const.years[
      safe: self.pickerView.selectedRow(
        inComponent: DateComponentType.year.rawValue
      )
    ] ?? currentDate.year

    let month = Const.months[
      safe: self.pickerView.selectedRow(
        inComponent: DateComponentType.month.rawValue
      )
    ] ?? currentDate.month

    return Date(year: year, month: month, day: 1)
  }

  // MARK: initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.configure()

    self.pickerView.delegate = self
    self.pickerView.dataSource = self
    self.setDefaultRow()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configure() {
    self.addSubview(self.pickerView)

    self.pickerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func setDefaultRow() {
    let currentDate = Date()

    self.pickerView.selectRow(
      Const.years.firstIndex(where: { $0 == currentDate.year}) ?? 0,
      inComponent: DateComponentType.year.rawValue,
      animated: false
    )

    self.pickerView.selectRow(
      Const.months.firstIndex(where: { $0 == currentDate.month}) ?? 0,
      inComponent: DateComponentType.month.rawValue,
      animated: false
    )
  }
}


// MARK: - UIPickerViewDataSource

extension JSDatePicker: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    guard let component = DateComponentType(rawValue: component) else { return 0 }

    switch component {
    case .year:
      return Const.years.count

    case .month:
      return Const.months.count
    }
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    guard let component = DateComponentType(rawValue: component) else { return "" }

    switch component {
    case .year:
      return "\(Const.years[safe: row] ?? 0)"

    case .month:
      return "\(Const.months[safe: row] ?? 0)"
    }
  }
}


// MARK: - UIPickerViewDelegate

extension JSDatePicker: UIPickerViewDelegate {

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

  }
}
