//
//  SyncTableDirectorInput.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 31.05.2020.
//

import Foundation

public protocol SyncTableDirectorInput: TableDirectorInput {
	/// Reload table view with provided sections
	/// - Parameters:
	///   - sections: new table sections
	///   - reloadRule: update table rule
	///   - completion: calls when operation if finished
	func reload(with sections: [TableSection], reloadRule: TableDirector.ReloadRule, completion:  @escaping () -> Void)

	/// Reload table view with provided sections
	/// - Parameters:
	///   - rows: new table view rows
	///   - reloadRule: update table rule
	///   - completion: calls when operation if finished
	func reload(with rows: [CellConfigurator], reloadRule: TableDirector.ReloadRule, completion:  @escaping () -> Void)
}
