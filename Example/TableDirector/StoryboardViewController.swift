//
//  StoryboardViewController.swift
//  TableDirector
//
//  Created by aleksiosdev on 04/12/2020.
//  Copyright (c) 2020 aleksiosdev. All rights reserved.
//

import UIKit
import TableDirector

class StoryboardViewController: UIViewController {
	// MARK: - UI
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties
	private var _tableDirector: TableDirectorInput?

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

		_tableDirector = TableDirector(tableView: tableView)
		_registerCells(in: tableView)
		let rows = _loadData()
		_tableDirector?.reload(with: rows)
    }

	private func _registerCells(in tableView: UITableView) {
		tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
		tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
	}

	private func _loadData() -> [[CellConfigurator]] {
		let placeholderImage = UIImage(named: "placeholder")
		let feedRow = TableRow<FeedCell>(item: .init(title: "Title", content: "Description", image: placeholderImage))
		let infoRow = TableRow<InfoCell>(item: .init(title: "Info Title", content: "Info content"))
		return [[feedRow, infoRow]]
	}
}
