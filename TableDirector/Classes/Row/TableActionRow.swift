//
//  TableActionRow.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

public final class TableActionRow<CellType: ActionCell>: CellConfigurator where CellType: UITableViewCell {
	public var cellClass: UITableViewCell.Type { return CellType.self }

	let item: CellType.ViewModel
	public private(set) var diffableItem: DiffInformation = .randomItem
	// Delegate must be weak or we gonna have big memory issue
	weak var delegate: AnyObject?

	// Store item and delegate
	public init(item: CellType.ViewModel, delegate: CellType.Delegate) {
		self.item = item
		// Here is some hack that I'll expalin under code
		self.delegate = delegate as AnyObject
	}

	public func configure(cell: UITableViewCell) {
		guard let cellWithType = cell as? CellType else {
			fatalError()
		}
		cellWithType.configure(item)
		// Put Delegate inside
		cellWithType.delegate = delegate as? CellType.Delegate
	}
}

// MARK: - CellType.ViewModel: Equatable
extension TableActionRow where CellType.ViewModel: DiffableViewModel {
	public convenience init(diffableModel: DiffableModel<CellType>, delegate: CellType.Delegate) {
		self.init(item: diffableModel.viewModel, delegate: delegate)
		diffableItem = diffableModel.diffableItem
	}
}
