//
//  TableRow.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

// We need geenric CellType - we gonna take all information from there.
// Also we should check if CellType is tableViewCell. Our protocol can be used for collectionView also
public final class TableRow<CellType: ConfigurableCell>: CellConfigurator where CellType: UITableViewCell {
	public var cellClass: UITableViewCell.Type { return CellType.self }

	var item: CellType.ViewModel

	public init(item: CellType.ViewModel) {
		self.item = item
	}

	/// Сonfigure cell with view model
	/// - Parameter cell: cell to configurate
	public func configure(cell: UITableViewCell) {
		// This check is more for compilator - cause we use this object to ger reuseID.
		// Out cell, that UITableViewDataSource will provide always conformed to CellType
		guard let cellWithType = cell as? CellType else {
			fatalError()
		}
		cellWithType.configure(item)
	}
}
