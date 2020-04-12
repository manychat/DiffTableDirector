//
//  CodeViewController.swift
//  TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TableDirector

class CodeViewController: UIViewController {
	// MARK: - UI
	private let _tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		return tableView
	}()

	// MARK: - Properties
	var rows: [[CellConfigurator]] = [[]]

	// MARK: - Init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(_tableView)
		_tableView.delegate = self
		_tableView.dataSource = self
		_tableView.translatesAutoresizingMaskIntoConstraints = false
		
		[_tableView.topAnchor.constraint(equalTo: view.topAnchor),
			_tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			_tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			_tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
			].forEach { $0.isActive = true }

		_registerCells(in: _tableView)
		rows = _loadData()
		_tableView.reloadData()
	}

	private func _registerCells(in tableView: UITableView) {
		tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
		tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
	}

	private func _loadData() -> [[CellConfigurator]] {
		let placeholderImage = UIImage(named: "placeholder")
		let infoRow = TableRow<InfoCell>(item: .init(title: "Info Title", content: "Info content"))
		let feedRow = TableRow<FeedCell>(item: .init(title: "Title", content: "Description", image: placeholderImage))
		return [[infoRow, feedRow]]
	}
}

// MARK: - UITableViewDelegate
extension CodeViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}

// MARK: - UITableViewDelegate
extension CodeViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rows[section].count
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return rows.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// Our logic transform in 4 steps
		// 1. Take view model
		let item = rows[indexPath.section][indexPath.row]
		// 2. Create cell
		let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId, for: indexPath)
		// 3. Configure cell
		item.configure(cell: cell)
		// 4. Return result
		return cell
	}
}
