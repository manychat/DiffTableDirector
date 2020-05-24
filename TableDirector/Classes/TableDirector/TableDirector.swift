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
	private let _boundsCrossObserver: ScrollViewBoundsCrossObserver
	private let _coverController: CoverView.Controller
	private let _sectionsComporator: SectionsComporator
	private var _sections: [TableSection] = [] {
		didSet {
			_changeCoverViewVisability(isSectionsEmpty: _sections.isEmpty)
		}
	}

	private var _defaultCoverViewShowParams: CoverView.ShowParams?
	private var _canShowEmptyView: Bool = true
	private lazy var pagination: Pagination? = {
		guard let tableView = _tableView else { return nil }
		return Pagination(tableView: tableView)
	}()

	// We need access to table view to perform some task. Object responsible for UI will retain table view
	private weak var _tableView: UITableView?

	// Give us ability to switch off self registration
	public var isSelfRegistrationEnabled: Bool

	public var topCrossObserver: ThresholdCrossObserver?
	public var bottomCrossObserver: ThresholdCrossObserver?

	/// Create instance with table view
	/// - Parameter tableView: table view to controll
	public init(tableView: UITableView, isSelfRegistrationEnabled: Bool = true) {
		self._tableView = tableView
		self._registrator = Registrator(tableView: tableView)
		self._boundsCrossObserver = ScrollViewBoundsCrossObserver(scrollView: tableView)
		self._coverController = CoverView.Controller()
		self._sectionsComporator = SectionsComporator()
		self.isSelfRegistrationEnabled = isSelfRegistrationEnabled

		super.init()

		tableView.delegate = self
		tableView.dataSource = self

		// We need to provide some height or in case your return automaticDimension height for header/footer
		// viewForHeaderInSection/viewForFooterInSection won't trigger
		tableView.estimatedSectionFooterHeight = 1
		tableView.estimatedSectionHeaderHeight = 1

		// Providing base extimate height for rows remove lags in scroll indicator and increase performance
		tableView.estimatedRowHeight = 1
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
	public func reload(with sections: [TableSection], reloadRule: TableDirector.ReloadRule) {
		let update = _sectionsComporator.calculateUpdate(oldSections: _sections, newSections: sections)
		_tableView?.reload(update: update, updateSectionsBlock: {
			self._sections = sections
		})
	}

	public func reload(with rows: [CellConfigurator], reloadRule: TableDirector.ReloadRule) {
		self._sections = [TableSection(rows: rows)]
		reload(with: _sections, reloadRule: reloadRule)
	}

	public func indexPath(for cell: UITableViewCell) -> IndexPath? {
		return _tableView?.indexPath(for: cell)
	}

	public func add(paginationController: PaginationController) {
		switch paginationController.direction {
		case .up:
			pagination?.topController = paginationController
		case .down:
			pagination?.bottomController = paginationController
		}
		guard let tableView = _tableView else { return }
		paginationController.add(to: tableView)
		paginationController.output = self
		tableView.prefetchDataSource = self
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

extension TableDirector: UITableViewDataSourcePrefetching {
	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		pagination?.topController?.prefetchIfNeeded(tableView: tableView, indexPaths: indexPaths, sections: _sections)
		pagination?.bottomController?.prefetchIfNeeded(tableView: tableView, indexPaths: indexPaths, sections: _sections)
	}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) { }
}

extension TableDirector: PaginationControllerOutput {
	func scrollToThreshold(direction: PaginationController.Direction, offset: CGFloat) {
		guard let tableView = _tableView else { return }
		let tableHeight = tableView.bounds.height
		let rectSize = CGSize(width: 1, height: tableHeight)
		switch direction {
		case .up:
			let topPoint = CGPoint(x: 0, y: tableView.contentInset.top + offset)
			tableView.scrollRectToVisible(.init(origin: topPoint, size: rectSize), animated: true)
		case .down:
			let yOrigin = tableView.contentSize.height - tableView.contentInset.bottom - tableHeight + offset
			_tableView?.scrollRectToVisible(.init(origin: .init(x: 0, y: yOrigin), size: rectSize), animated: true)
		}
	}

	func changeTopContentInset(newOffset: CGFloat) {
		_tableView?.contentInset.top += newOffset
	}
}
