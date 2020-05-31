//
//  TableDirectorInput.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Interface for TableDirector. Provides all nessasry operation for users
public protocol TableDirectorInput: class {
	var topCrossObserver: ThresholdCrossObserver? { get set }
	var bottomCrossObserver: ThresholdCrossObserver? { get set }

	var isSelfRegistrationEnabled: Bool { get set }

	/// Add pagination controller to table view.
	/// If pagination controller with provided direction already exist - it will be replaced with new one
	/// - Parameter paginationController: control pagination proccess
	func add(paginationController: PaginationController)

	/// Reload table view with provided sections
	/// - Parameter sections: new table sections
	func reload(with sections: [TableSection])

	/// Reload table view with provided sections
	/// - Parameters:
	///   - sections: new table sections
	///   - reloadRule: update table rule
	func reload(with sections: [TableSection], reloadRule: TableDirector.ReloadRule)

	/// Reload table view with single sections containig provider rows
	/// - Parameter rows: new table view rows
	func reload(with rows: [CellConfigurator])

	/// Reload table view with single sections containig provider rows
	/// - Parameters:
	///   - rows: new table view rows
	///   - reloadRule: update table rule
	func reload(with rows: [CellConfigurator], reloadRule: TableDirector.ReloadRule)

	/// Got index path of cell if it exist in table view
	/// - Parameter cell: table cell to find indexPath
	func indexPath(for cell: UITableViewCell) -> IndexPath?

	/// Add view that weill be shown if table content is empty
	/// TableDirector will retatin view, so keep it in mind
	/// - Parameters:
	///   - view: view to show inside table
	///   - position: information how to place view inside table view
	func addEmptyStateView(view: UIView, position: TableDirector.CoverView.Position)

	/// Clear current table content and show info view with settings
	/// If will replace empty view if there is any in table
	/// - Parameters:
	///   - view: view to show inside table
	///   - position: information how to place view inside table view
	func clearAndShowView(view: UIView, position: TableDirector.CoverView.Position)
}

// MARK: - Default implementation
extension TableDirectorInput {
	public func reload(with sections: [TableSection]) {
		reload(with: sections, reloadRule: .fullReload)
	}

	public func reload(with rows: [CellConfigurator]) {
		reload(with: rows, reloadRule: .fullReload)
	}
}
