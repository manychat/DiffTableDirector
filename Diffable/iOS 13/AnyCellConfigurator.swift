//
//  AnyCellConfigurator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 31.05.2020.
//

import Foundation

struct AnyCellConfigurator: Hashable {
	static func == (lhs: AnyCellConfigurator, rhs: AnyCellConfigurator) -> Bool {
		return lhs.cellConfigurator.diffableItem.diffId == rhs.cellConfigurator.diffableItem.diffId
	}

	let cellConfigurator: CellConfigurator
	init(cellConfigurator: CellConfigurator) {
		self.cellConfigurator = cellConfigurator
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(cellConfigurator.diffableItem.diffableKeys)
		hasher.combine(cellConfigurator.diffableItem.diffId)
	}
}
