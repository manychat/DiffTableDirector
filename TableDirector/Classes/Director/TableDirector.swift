//
//  TableDirector.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import UIKit

// We have to inheritance NSObject - tableView delegates require it
/// Perform all work with table view
public final class TableDirector: NSObject {
	private let _registrator: Registrator
	private let _coverController: CoverView.Controller
	private var _sections: [TableSection] = [] {
		didSet {
			_changeCoverViewVisability(isSectionsEmpty: _sections.isEmpty)
		}
	}
	private var _defaultCoverViewShowParams: CoverView.ShowParams?
	private var _canShowEmptyView: Bool = true

	// We need access to table view to perform some task. Object responsible for UI will retain table view
	private weak var _tableView: UITableView?

	// Give us ability to switch off self registration
	public var isSelfRegistrationEnabled: Bool

	/// Create instance with table view
	/// - Parameter tableView: table view to controll
	public init(tableView: UITableView, isSelfRegistrationEnabled: Bool = true) {
		self._tableView = tableView
		self._registrator = Registrator(tableView: tableView)
		self._coverController = CoverView.Controller()
		self.isSelfRegistrationEnabled = isSelfRegistrationEnabled
		super.init()

		tableView.delegate = self
		tableView.dataSource = self

		// We need to provide some height or in case your return automaticDimension height for header/footer
		// viewForHeaderInSection/viewForFooterInSection won't trigger
		tableView.estimatedSectionFooterHeight = 1
		tableView.estimatedSectionHeaderHeight = 1
	}

	private func _createHeaderFooterView(with configurator: HeaderConfigurator, tableView: UITableView) -> UIView? {
		if isSelfRegistrationEnabled {
			_registrator.registerIfNeeded(headerFooterClass: configurator.viewClass)
		}
		let reuseId = configurator.viewClass.reuseIdentifier
		guard let headerFooterView = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseId) else {
			assertionFailure("Probably you forgot to register \(reuseId) in tableView")
			return nil
		}
		configurator.configure(view: headerFooterView)
		return headerFooterView
	}

	private func _changeCoverViewVisability(isSectionsEmpty: Bool) {
		if let coverViewParams = _defaultCoverViewShowParams,
			let tableView = _tableView,
			isSectionsEmpty,
			_canShowEmptyView {
			_coverController.add(
				view: coverViewParams.coverView,
				to: tableView,
				position: coverViewParams.position)
			return
		}
		_coverController.hide()
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

	public func addEmptyStateView(view: UIView, position: TableDirector.CoverView.Position) {
		_defaultCoverViewShowParams = .init(coverView: view, position: position)
		if _sections.isEmpty {
			guard let tableView = _tableView else { return }
			_coverController.add(view: view, to: tableView, position: position)
		}
	}

	public func clearAndShowView(view: UIView, position: TableDirector.CoverView.Position) {
		guard let tableView = _tableView else { return }
		defer { _canShowEmptyView = true }
		_canShowEmptyView = false
		_sections = []
		_tableView?.reloadData()
		_coverController.add(view: view, to: tableView, position: position)
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
		if isSelfRegistrationEnabled {
			_registrator.registerIfNeeded(cellClass: item.cellClass)
		}
		let cell = tableView.dequeueReusableCell(
			withIdentifier: item.cellClass.reuseIdentifier,
			for: indexPath)
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
