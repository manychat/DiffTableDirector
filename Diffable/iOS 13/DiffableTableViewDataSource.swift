//
//  AppleStructComparator.swift
//  DeepDiff
//
//  Created by Aleksandr Lavrinenko on 30.05.2020.
//

import Foundation

@available(iOS 13.0, *)
final class DiffableTableViewDataSource: UITableViewDiffableDataSource<AnyHeaderConfigurator, AnyCellConfigurator>, DiffableDataSource {
	func apply(snapshot: Snapshot) {
		guard let snapshot = snapshot as? NSDiffableDataSourceSnapshot<AnyHeaderConfigurator, AnyCellConfigurator> else { return }
		apply(snapshot)
	}
}
