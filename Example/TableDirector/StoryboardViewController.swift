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
	@IBOutlet weak var tablView: UITableView!

	// MARK: - Properties
	var rows: [[CellConfigurator]] = [[]]

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}

// MARK: - UITableViewDelegate
extension StoryboardViewController: UITableViewDelegate {

}

// MARK: - UITableViewDelegate
extension StoryboardViewController: UITableViewDataSource {
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
