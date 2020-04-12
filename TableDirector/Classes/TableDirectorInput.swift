//
//  TableDirectorInput.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Interface for TableDirector. Provides all nessasry operation for users
public protocol TableDirectorInput: class {

	/// Reload table view with provided rows
	/// - Parameter rows: new table rows
	func reload(with rows: [[CellConfigurator]])
}
