//
//  SyncTableDirector.swift
//  DeepDiff
//
//  Created by Aleksandr Lavrinenko on 31.05.2020.
//

import Foundation

public final class SyncTableDirector {
	private let _tableDirector: TableDirector

	private var _reloadQueue: [() -> Void] = []

	public init(tableView: UITableView, isSelfRegistrationEnabled: Bool = true) {
		_tableDirector = TableDirector(
			tableView: tableView,
			isSelfRegistrationEnabled: isSelfRegistrationEnabled)
	}

	private func _syncReload(
		with sections: [TableSection],
		reloadRule: TableDirector.ReloadRule,
		completion: (() -> Void)?) {
		let reloadOperation: () -> Void = { [weak self] in
			self?._tableDirector.reload(with: sections, reloadRule: reloadRule, completion: { [weak self] in
				completion?()

				guard let self = self else { return }
				guard !self._reloadQueue.isEmpty else { return }
				let nextOperation = self._reloadQueue.removeFirst()
				nextOperation()
			})
		}
		if _reloadQueue.isEmpty {
			reloadOperation()
		}
		_reloadQueue.append(reloadOperation)
	}
}

// MARK: - TableDirectorInput
extension SyncTableDirector: SyncTableDirectorInput {
	public func reload(with rows: [CellConfigurator], reloadRule: TableDirector.ReloadRule) {
		_syncReload(with: [TableSection(rows: rows)], reloadRule: reloadRule, completion: nil)
	}

	public func reload(
		with rows: [CellConfigurator],
		reloadRule: TableDirector.ReloadRule,
		completion:  @escaping () -> Void) {
		reload(with: [TableSection(rows: rows)], reloadRule: reloadRule)
	}

	public func reload(
		with sections: [TableSection],
		reloadRule: TableDirector.ReloadRule,
		completion: @escaping () -> Void) {
		_syncReload(with: sections, reloadRule: reloadRule, completion: completion)
	}

	public func reload(with sections: [TableSection], reloadRule: TableDirector.ReloadRule) {
		_syncReload(with: sections, reloadRule: reloadRule, completion: nil)
	}

	public var topCrossObserver: ThresholdCrossObserver? {
		get {
			_tableDirector.topCrossObserver
		}
		set {
			_tableDirector.topCrossObserver = newValue
		}
	}

	public var bottomCrossObserver: ThresholdCrossObserver? {
		get {
			_tableDirector.bottomCrossObserver
		}
		set {
			_tableDirector.bottomCrossObserver = newValue
		}
	}

	public var isSelfRegistrationEnabled: Bool {
		get {
			_tableDirector.isSelfRegistrationEnabled
		}
		set {
			_tableDirector.isSelfRegistrationEnabled = newValue
		}
	}

	public func add(paginationController: PaginationController) {
		_tableDirector.add(paginationController: paginationController)
	}

	public func indexPath(for cell: UITableViewCell) -> IndexPath? {
		_tableDirector.indexPath(for: cell)
	}

	public func addEmptyStateView(view: UIView, position: TableDirector.CoverView.Position) {
		_tableDirector.addEmptyStateView(view: view, position: position)
	}

	public func clearAndShowView(view: UIView, position: TableDirector.CoverView.Position) {
		_tableDirector.clearAndShowView(view: view, position: position)
	}
}
