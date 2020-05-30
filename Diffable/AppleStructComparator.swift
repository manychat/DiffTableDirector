//
//  AppleStructComparator.swift
//  DeepDiff
//
//  Created by Aleksandr Lavrinenko on 30.05.2020.
//

import Foundation

struct AnyCellConfigurator: Hashable {
	static func == (lhs: AnyCellConfigurator, rhs: AnyCellConfigurator) -> Bool {
		return lhs.hashValue == rhs.hashValue
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

struct AnyHeaderConfigurator: Hashable {
	static func == (lhs: AnyHeaderConfigurator, rhs: AnyHeaderConfigurator) -> Bool {
		return lhs.hashValue == rhs.hashValue
	}

	let headerConfigurator: HeaderConfigurator

	init(headerConfigurator: HeaderConfigurator) {
		self.headerConfigurator = headerConfigurator
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(headerConfigurator.viewClass.description())
//		hasher.combine(headerConfigurator.diffableItem.diffId)
	}
}

@available(iOS 13.0, *)
final class DiffableTableViewDataSource: UITableViewDiffableDataSource<AnyHeaderConfigurator, AnyCellConfigurator>, DiffableDataSource {
	func headerProviderMethod(tableView: UITableView, indexPath: IndexPath, anyHeaderConfigurator: AnyHeaderConfigurator) {
		
	}

	func apply(snapshot: Snapshot) {
		guard let snapshot = snapshot as?  NSDiffableDataSourceSnapshot<AnyHeaderConfigurator, AnyCellConfigurator> else { return }
		apply(snapshot)
	}
}
