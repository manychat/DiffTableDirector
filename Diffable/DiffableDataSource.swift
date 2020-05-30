//
//  DiffableDataSource.swift
//  DeepDiff
//
//  Created by Aleksandr Lavrinenko on 30.05.2020.
//

import Foundation

protocol DiffableDataSource {
	func headerProviderMethod(tableView: UITableView, indexPath: IndexPath, anyHeaderConfigurator: AnyHeaderConfigurator)

	func apply(snapshot: Snapshot)
}
