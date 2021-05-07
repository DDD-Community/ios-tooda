//
//  HomeViewController.swift
//  Toda
//
//  Created by lyine on 2021/04/05.
//

import UIKit

import ReactorKit
import RxCocoa
import RxViewController
import RxDataSources

import SnapKit
import Then

class HomeViewController: UIViewController, View {
	
	var disposeBag: DisposeBag = DisposeBag()
	
	typealias Reactor = HomeViewReactor
	typealias Section = RxTableViewSectionedAnimatedDataSource<ColorSection>
	
	enum Constants {
		static let colorCell = "\(ColorCell.self)"
	}
	
	lazy var dataSource = Section(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
		switch item {
			case .item(let reactor):
				guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.colorCell, for: indexPath) as? ColorCell else {
					return UITableViewCell()
				}
				
				cell.configure(reactor: reactor)
				return cell
		}
	}, canEditRowAtIndexPath: { _, _ in
		return true
	})
	
	// MARK: UI-Properties
	
	let rightBarButton = UIBarButtonItem().then {
		$0.title = "Edit"
		$0.style = .plain
	}

	let tableView = UITableView().then {
		$0.separatorStyle = .singleLine
		$0.backgroundColor = .white
		$0.allowsSelection = true
		
		$0.register(ColorCell.self, forCellReuseIdentifier: Constants.colorCell)
	}
	
	// MARK: Properties
		
	init(reactor: Reactor) {
		
		defer {
			self.reactor = reactor
		}
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required convenience init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		configureNavigation()
		configureUI()
		setupConstraints()
		
		print(appName())
		print(appBundleID())
	}
	
	func configureNavigation() {
		self.navigationItem.title = "Colors"
		self.navigationItem.rightBarButtonItem = rightBarButton
	}

	
	func configureUI() {
		
		self.view.backgroundColor = .white
		
		[tableView].forEach {
			self.view.addSubview($0)
		}
	}
	
	func setupConstraints() {
		tableView.snp.makeConstraints {
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
			$0.left.right.equalToSuperview()
		}
	}

	
	func bind(reactor: Reactor) {
		
		// Action
		self.rx.viewDidLoad
			.map { _ in Reactor.Action.fetchColors }
			.bind(to: reactor.action)
			.disposed(by: self.disposeBag)
		
		self.tableView.rx.itemDeleted
			.map { Reactor.Action.removeItem($0.row) }
			.bind(to: reactor.action)
			.disposed(by: self.disposeBag)
		
		self.rightBarButton.rx.tap
			.throttle(.milliseconds(5), scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] _ in
				self?.changeTableViewMode()
			}).disposed(by: self.disposeBag)
		
		// State
		self.reactor?.state
			.map { $0.sections }
			.bind(to: self.tableView.rx.items(dataSource: dataSource))
			.disposed(by: self.disposeBag)
		
		self.tableView.rx.setDelegate(self).disposed(by: self.disposeBag)
	}
	
	func changeTableViewMode() {
		if self.tableView.isEditing {
			self.rightBarButton.title = "Edit"
			self.tableView.setEditing(false, animated: true)
		} else {
			self.rightBarButton.title = "Done"
			self.tableView.setEditing(true, animated: true)
		}
	}
}

extension HomeViewController: UIScrollViewDelegate {}

extension HomeViewController: UITableViewDelegate {
	// Edit Mode에서 Row별 모드 지정
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		if indexPath.row == 0 {
			return .insert
		} else {
			return .delete
		}
	}
}
