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

	public init(diffId: String, viewModel: CellType.ViewModel) {
		self.diffId = diffId
		self.viewModel = viewModel
	}

	var diffableItem: DiffInformation {
		return DiffInformation(diffId: diffId, diffableKeys: viewModel.diffableKeys)
	}
}
