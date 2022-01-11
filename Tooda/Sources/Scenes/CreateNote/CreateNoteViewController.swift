//
//  CreateNoteViewController.swift
//  Tooda
//
//  Created by Lyine on 2021/05/19.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

import RxViewController
import RxCocoa
import RxDataSources
import ReactorKit
import SnapKit

class CreateNoteViewController: BaseViewController<CreateNoteViewReactor> {
  typealias Reactor = CreateNoteViewReactor

  typealias Section = RxTableViewSectionedAnimatedDataSource<NoteSection>
  
  private enum Metric {
    static let linkButtonSize: CGFloat = 20.0
  }

  // MARK: Custom Action
  
  let imageItemCellDidTapRelay: PublishRelay<IndexPath> = PublishRelay()
  let imagePickerDataSelectedRelay: PublishRelay<Data> = PublishRelay()
  
  let rxAddStockDidTapRelay: PublishRelay<Void> = PublishRelay()
  
  private let rxStockItemDeleteRelay: PublishRelay<IndexPath> = PublishRelay()
  
  private let rxStockItemDidEditRelay: PublishRelay<IndexPath> = PublishRelay()
  
  private let rxCombinedTextDidChangedRelay: PublishRelay<(title: String, content: String)> = PublishRelay()
  
  // MARK: Properties
  lazy var dataSource: Section = Section(configureCell: { _, tableView, indexPath, item -> UITableViewCell in
    switch item {
    case .content(let reactor):
      let cell = tableView.dequeue(NoteContentCell.self, indexPath: indexPath)
      cell.configure(reactor: reactor)
        
      cell.rx.combinedTextDidChanged
        .map { (title: $0.0, content: $0.1) }
        .bind(to: self.rxCombinedTextDidChangedRelay)
        .disposed(by: cell.disposeBag)
        
      return cell
    case .addStock(let reactor):
      let cell = tableView.dequeue(EmptyNoteStockCell.self, indexPath: indexPath)
      cell.configure(reactor: reactor)
        
      cell.rx.didTapAddStock
        .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        .bind(to: self.rxAddStockDidTapRelay)
        .disposed(by: cell.disposeBag)
        
      return cell
    case .image(let cellReactor):
      let cell = tableView.dequeue(NoteImageCell.self, indexPath: indexPath)
      cell.configure(reactor: cellReactor)
      
      cell.rx.didSelectedItemCell
        .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
        .bind(to: self.imageItemCellDidTapRelay)
        .disposed(by: cell.disposeBag)
      
      cell.selectionStyle = .none
      
      return cell
    case .stock(let reactor):
        let cell = tableView.dequeue(NoteStockCell.self, indexPath: indexPath)
        cell.configure(with: reactor)
        return cell
    case .link(let reactor):
        let cell = tableView.dequeue(NoteLinkCell.self, indexPath: indexPath)
        cell.configure(reactor: reactor)
        return cell
    }
  }, canEditRowAtIndexPath: { _, _ in true })
  
  private let dateString: String

  // MARK: UI-Properties
  
  private lazy var titleLabel = UILabel().then {
    $0.attributedText = self.dateString.styled(with: TextStyle.subTitle(color: .gray1))
  }
  
  private let closeBarbutton = UIBarButtonItem(image: UIImage(type: .iconCancelBlack),
                                               style: .plain,
                                               target: nil,
                                               action: nil)
  
  private let registerButton = BaseButton(width: 53, height: 28).then {
    $0.setButtonTitle(with: "등록", style: TextStyle.body2Bold(color: UIColor.white))
    $0.configureShadow(color: .clear, x: 0, y: 0, blur: 0, spread: 0)
  }
  
  private lazy var rightBarButton = UIBarButtonItem(customView: self.registerButton)

  private lazy var tableView = UITableView().then {
    $0.separatorStyle = .none
    $0.backgroundColor = .white
    $0.estimatedRowHeight = UITableView.automaticDimension
    $0.alwaysBounceHorizontal = false
    
    $0.allowsSelection = false
    
    $0.delegate = self

    $0.register(NoteContentCell.self)
    $0.register(EmptyNoteStockCell.self)
    $0.register(NoteImageCell.self)
    $0.register(NoteStockCell.self)
    $0.register(NoteLinkCell.self)
  }
  
  private let linkStackView = UIStackView().then {
    $0.axis = .vertical
    $0.alignment = .fill
    $0.spacing = 8.0
  }
  
  private let lineView = UIView().then {
    $0.backgroundColor = .gray5
  }
  
  private let linkContainerView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let linkButton = UIButton().then {
    $0.setImage(UIImage(type: .link), for: .normal)
  }

  // MARK: Initialize

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(dateString: String, reactor: Reactor) {
    defer {
      self.reactor = reactor
    }
    
    self.dateString = dateString
    super.init()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureNavigation()
    configureTapGesture()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func configureUI() {
    super.configureUI()

    self.view.backgroundColor = .white

    [tableView, linkStackView].forEach {
      self.view.addSubview($0)
    }
    
    [lineView, linkContainerView].forEach {
      self.linkStackView.addArrangedSubview($0)
    }
    
    self.linkContainerView.addSubview(self.linkButton)
  }

  override func configureConstraints() {
    super.configureConstraints()

    tableView.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(16)
      $0.left.equalToSuperview().offset(14)
      $0.right.equalToSuperview().offset(-14)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
    }
    
    linkStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
    }
    
    lineView.snp.makeConstraints {
      $0.height.equalTo(1)
    }
    
    linkButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(14)
      $0.size.equalTo(Metric.linkButtonSize)
    }
  }

  override func bind(reactor: Reactor) {
    super.bind(reactor: reactor)

    // Action
    self.closeBarbutton.rx.tap
      .map { Reactor.Action.dismissView }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.rx.viewDidLoad
      .map { _ in Reactor.Action.initializeForm }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.linkButton.rx.tap
      .map { _ in Reactor.Action.linkButtonDidTapped }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    self.registerButton.rx.tap
      .map { _ in Reactor.Action.registerButtonDidTapped }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    imageItemCellDidTapRelay
      .map { Reactor.Action.didSelectedImageItem($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    imagePickerDataSelectedRelay
      .map { Reactor.Action.uploadImage($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    rxAddStockDidTapRelay
      .map { Reactor.Action.showAddStockView }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    rxCombinedTextDidChangedRelay
      .map { Reactor.Action.makeTitleAndContent(title: $0.title, content: $0.content)}
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    // State
    reactor.state
      .map { $0.sections }
      .bind(to: self.tableView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
    reactor.state
      .compactMap { $0.presentType }
      .asDriver(onErrorJustReturn: .showPhotoPicker)
      .drive(onNext: { [weak self] in
        self?.present(by: $0)
      }).disposed(by: self.disposeBag)
    
    reactor.state
      .map { $0.shouldReigsterButtonEnabled }
      .asDriver(onErrorJustReturn: false)
      .drive(onNext: { [weak self] in
        self?.registerButton.setOnOff(isOn: $0)
      }).disposed(by: self.disposeBag)
  }
}

// MARK: ViewController Configuration

extension CreateNoteViewController {
  func configureNavigation() {
    self.navigationItem.titleView = self.titleLabel
    self.navigationItem.leftBarButtonItem = self.closeBarbutton
    self.navigationItem.rightBarButtonItem = self.rightBarButton
  }
  
  private func configureTapGesture() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(contentViewDidTap))
    self.view.addGestureRecognizer(tapGesture)
  }
  
  @objc
  private func contentViewDidTap(_ sender: Any?) {
    self.view.endEditing(true)
  }
}

// MARK: ETC

extension CreateNoteViewController {
  func present(by: Reactor.ViewPresentType) {
    switch by {
      case .showAlert(let message):
        self.showAlert(message: message)
      case .showPermission(let message):
        self.showAlertAndOpenAppSetting(message: message)
      case .showPhotoPicker:
        self.showPhotoPicker()
    }
  }
  
  func showAlert(message: String?) {
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction.init(title: "확인", style: .default, handler: nil)
    
    alertController.addAction(ok)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func showAlertAndOpenAppSetting(message: String?) {
    
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction.init(title: "확인", style: .default, handler: { [weak self] _ in
      self?.openAppSettingMenu()
    })
    
    alertController.addAction(ok)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  private func showPhotoPicker() {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
      self?.showPickView(by: .camera)
    }
    let album = UIAlertAction(title: "앨범", style: .default) { [weak self] _ in
      self?.showPickView(by: .photoLibrary)
    }
    
    alert.addAction(cancel)
    alert.addAction(camera)
    alert.addAction(album)
    
    present(alert, animated: true, completion: nil)
  }
  
  private func showPickView(by: UIImagePickerController.SourceType) {
    let vc = UIImagePickerController()
    vc.sourceType = by
    vc.delegate = self
    vc.allowsEditing = true
    
    present(vc, animated: true, completion: nil)
  }
}

extension CreateNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[.editedImage] as? UIImage, let imageData = image.jpegData(compressionQuality: 1.0) {
      self.imagePickerDataSelectedRelay.accept(imageData)
    }
    
    picker.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableView Delegate

extension CreateNoteViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return self.generateEditableSwipeConfigure(at: indexPath)
  }
}

// MARK: - Generate UISwipeActionsConfiguration

extension CreateNoteViewController {
  private func generateEditableSwipeConfigure(at indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    switch dataSource[indexPath] {
      case .stock:
        let delete = self.deleteCellAction(at: indexPath)
        
        let edit = self.editCellAction(at: indexPath)
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete, edit])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
      default:
        return nil
    }
  }
  
  private func deleteCellAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
      
      let alertController = UIAlertController(title: nil, message: "종목을 삭제하시겠습니까?", preferredStyle: .alert)
      
      let ok = UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
        self?.rxStockItemDeleteRelay.accept(indexPath)
      })
      
      let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
      
      alertController.addAction(cancel)
      alertController.addAction(ok)
      
      self?.present(alertController, animated: true, completion: nil)
      
      completionHandler(true)
    }
    
    return action
  }
  
  private func editCellAction(at indexPath: IndexPath) -> UIContextualAction {
    let action = UIContextualAction(style: .normal, title: "수정") { [weak self] _, _, completionHandler in
      self?.rxStockItemDidEditRelay.accept(indexPath)
      completionHandler(true)
    }
    
    return action
  }
}
