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
	private var _sections: [TableSection] = []
	// We need access to table view to perform some task. Object responsible for UI will retain table view
	private weak var _tableView: UITableView?

	/// Create instance with table view
	/// - Parameter tableView: table view to controll
	public init(tableView: UITableView) {
		self._tableView = tableView
		super.init()

		tableView.delegate = self
		tableView.dataSource = self

		// We need to provide some height or in case your return automaticDimension height for header/footer
		// viewForHeaderInSection/viewForFooterInSection won't trigger
		tableView.estimatedSectionFooterHeight = 1
		tableView.estimatedSectionHeaderHeight = 1
	}

	private func _createHeaderFooterView(with configurator: HeaderConfigurator, tableView: UITableView) -> UIView? {
		let reuseId = configurator.reuseId
		guard let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) else {
			assertionFailure("Probably you forgot to register \(configurator.reuseId) in tableView")
			return nil
		}
		configurator.configure(view: headerFooterView)
		return headerFooterView
	}
}

// MARK: - TableDirectorInput
extension TableDirector: TableDirectorInput {
	public func reload(with sections: [TableSection]) {
		self._sections = sections
		_tableView?.reloadData()
	}

	public func reload(with rows: [CellConfigurator]) {
		self._sections = [TableSection(rows: rows)]
		_tableView?.reloadData()
	}

	public func indexPath(for cell: UITableViewCell) -> IndexPath? {
		return _tableView?.indexPath(for: cell)
	}
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension TableDirector: UITableViewDelegate & UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return _sections[section].rows.count
	}

	public func numberOfSections(in tableView: UITableView) -> Int {
		return _sections.count
	}

	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = _sections[indexPath.section].rows[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: item.reuseId, for: indexPath)
		item.configure(cell: cell)
		return cell
	}

	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		// Let's build our cells usining AutoLayout.
		// As alternative it you use frame or smth different - you can store height information inside TableRow
		return UITableView.automaticDimension
	}

	public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		// Take configurator if threre is any
		guard let configurator = _sections[section].headerView else { return nil }
		return _createHeaderFooterView(with: configurator, tableView: tableView)
	}

	public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let configurator = _sections[section].footerView else { return nil }
		return _createHeaderFooterView(with: configurator, tableView: tableView)
	}

	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		guard _sections[section].headerView != nil else { return 0 }
		return UITableView.automaticDimension
	}

	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		guard _sections[section].footerView != nil else { return 0 }
		return UITableView.automaticDimension
	}
}
