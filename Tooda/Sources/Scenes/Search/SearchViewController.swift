//
//  SearchViewController.swift
//  Tooda
//
//  Created by Jinsu Park on 2021/10/25.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class SearchViewController: BaseViewController<SearchReactor> {

  // MARK: Constants

  private enum Font {
    static let placeholder = TextStyle.body2(color: .gray3)
    static let searchText = TextStyle.body2(color: .gray1)
  }


  // MARK: UI

  private let recentViewController: SearchRecentViewController
  private let resultViewController: SearchResultViewController

  private let searchBar = UISearchBar().then {
    $0.searchTextPositionAdjustment = .init(horizontal: 5.0, vertical: 0.0)
    $0.searchTextField.attributedPlaceholder = "전체 노트 중 검색".styled(with: Font.placeholder)
  }


  // MARK: Initializing

  init(
    reactor: SearchReactor,
    recentViewController: SearchRecentViewController,
    resultViewController: SearchResultViewController
  ) {
    self.recentViewController = recentViewController
    self.resultViewController = resultViewController
    super.init()
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.searchBar.becomeFirstResponder()
  }


  // MARK: Bind

  override func bind(reactor: SearchReactor) {

    // Action
    self.rx.viewDidLoad
      .asObservable()
      .flatMap { [weak self] _ -> Observable<Void> in
        guard let self = self else {
          return Observable<Void>.empty()
        }
        return self.configureBackBarButtonItemIfNeeded()
      }
      .map { SearchReactor.Action.back }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }

  override func configureUI() {
    super.configureUI()

    self.configureSearchBar()

    self.addChild(self.recentViewController)
    self.recentViewController.view.frame = self.view.frame
    self.view.addSubview(self.recentViewController.view)
    self.recentViewController.didMove(toParent: self)
  }

  override func configureConstraints() {

  }

  private func configureSearchBar() {
    self.navigationItem.titleView = self.searchBar
    self.searchBar.delegate = self

    let leftView = UIView(frame: .init(origin: .zero, size: .init(width: 30.0, height: 30.0)))
    let imageView = UIImageView(
      frame: .init(
        x: 10.0,
        y: 5.0,
        width: 20.0,
        height: 20.0
      )
    )
    imageView.image = UIImage(type: .searchBarButton)?.withRenderingMode(.alwaysTemplate)
    leftView.addSubview(imageView)
    imageView.tintColor = .gray3

    self.searchBar.searchTextField.leftView = imageView
  }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchBar.searchTextField.attributedText = searchText.styled(with: Font.searchText)
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    self.recentViewController.rxBeginSearch.accept(())
  }

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    self.searchBar.resignFirstResponder()
    guard let text = searchBar.text,
          text.isEmpty == false else { return }

    self.addResultViewControllerIfNeeded()

    self.recentViewController.view.isHidden = true
    self.recentViewController.rxSearch.accept(text)
  }
}


// MARK: - Internal

extension SearchViewController {

  private func addResultViewControllerIfNeeded() {
    guard self.resultViewController.view.superview == nil else { return }

    self.addChild(self.resultViewController)
    self.resultViewController.view.frame = self.view.frame
    self.view.addSubview(self.resultViewController.view)
    self.resultViewController.didMove(toParent: self)
  }
}
