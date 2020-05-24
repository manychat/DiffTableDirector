//
//  DiffableModel.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation
import DeepDiff

public struct DiffableModel<CellType: ConfigurableCell>
where CellType: UITableViewCell, CellType.ViewModel: DiffableViewModel {
	public let diffId: String
	public let viewModel: CellType.ViewModel

	var diffableItem: DiffableItem {
		return DiffableItem(diffId: diffId, diffableKeys: viewModel.diffableKeys)
	}
}
