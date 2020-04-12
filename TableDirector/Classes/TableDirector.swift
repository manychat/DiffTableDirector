//
//  TableDirector.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import UIKit

// We have to inheritance NSObject - tableView delegates require it
/// Perform all work with table view
public final class TableDirector: NSObject {
	private var _rows: [[CellConfigurator]] = [[]]
	// We need access to table view to perform some task. Object responsible for UI will retain table view
	private weak var _tableView: UITableView?


	/// Create instance with table view
	/// - Parameter tableView: table view to controll
	public init(tableView: UITableView) {
		self._tableView = tableView
		super.init()

		tableView.delegate = self
		tableView.dataSource = self
	}
}

// MARK: - TableDirectorInput
extension TableDirector: TableDirectorInput {
	public func reload(with rows: [[CellConfigurator]]) {
		self._rows = rows
		_tableView?.reloadData()
	}
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TableDirector: UITableViewDelegate & UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _rows[section].count
	}

	public func numberOfSections(in tableView: UITableView) -> Int {
		return _rows.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = _rows[indexPath.section][indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId, for: indexPath)
		item.configure(cell: cell)
		return cell
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		// Let's build our cells usining AutoLayout.
		// As alternative it you use frame or smth different - you can store height information inside TableRow
		return UITableView.automaticDimension
	}
}
