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

	/// Reload table view with provided rows
	/// - Parameter rows: new table sections
	func reload(with sections: [TableSection])

	/// Reload table view with single sections containig provider rows
	/// - Parameter rows: new table view rows
	func reload(with rows: [CellConfigurator])

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
