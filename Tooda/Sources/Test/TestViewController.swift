//
//  TestViewController.swift
//  Tooda
//
//  Created by lyine on 2021/04/28.
//  Copyright © 2021 DTS. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var editBarButtonItem: UIBarButtonItem!
	
	var dataSource: [String] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()

		self.configure()
		self.fetchData()
        // Do any additional setup after loading the view.
    }
	
	func configureUI() {
		
	}
	
	func configure() {
		self.tableView.delegate = self
		self.tableView.dataSource = self
	}
	
	func fetchData() {
		let data = ["Hello", "Kim", "Mike"]
		self.dataSource = data
	}
    

	@IBAction func didTapEditButton(_ sender: Any) {
		if self.tableView.isEditing {
			self.editBarButtonItem.title = "Edit"
			self.tableView.setEditing(false, animated: true)
		} else {
			self.editBarButtonItem.title = "Done"
			self.tableView.setEditing(true, animated: true)
		}
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController {
	static var identier: String {
		return String(describing: TestViewController.self)
	}
}

extension TestViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TestTableViewCell.identifier, for: indexPath) as? TestTableViewCell else { return UITableViewCell() }
		cell.title.text = dataSource[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		if indexPath.row == 0 {
			return .insert
		} else {
			return .delete
		}
	}
}

class TestTableViewCell: UITableViewCell {
	@IBOutlet weak var title: UILabel!
}

extension TestTableViewCell {
	static var identifier: String {
		return String(describing: TestTableViewCell.self)
	}
}
