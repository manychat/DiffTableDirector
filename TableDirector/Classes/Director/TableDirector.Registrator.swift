//
//  TableDirector.Registrator.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import Foundation

extension TableDirector {
	final class Registrator {
		private weak var _tableView: UITableView?

		// Store ID in set. Garanty uniq storage
		private var _registredCellID: Set<String> = []
		private var _registredHeaderFooterID: Set<String> = []

		// Don't make much sence without table
		init(tableView: UITableView) {
			_tableView = tableView
		}

		/// If cell is unregistered in talbe - register it. Otherwise do nothing
		/// - Parameter cellClass: cell class to register
		func registerIfNeeded(cellClass: UITableViewCell.Type) {
			let reuseIdentifier = cellClass.reuseIdentifier
			guard !_registredCellID.contains(reuseIdentifier) else { return }
			_registredCellID.insert(reuseIdentifier)

			// This method return not nil if we had registred item with provided ID
			let cell = _tableView?.dequeueReusableCell(withIdentifier: reuseIdentifier)
			guard cell == nil else { return }

			// Getting nib from class
			if let nib = cellClass.nib {
				_tableView?.register(nib, forCellReuseIdentifier: reuseIdentifier)
				return
			}
			_tableView?.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
		}

		/// If view is unregistered - register it. Otherwise do nothing
		/// - Parameter headerFooterClass: footer/header class to register
		func registerIfNeeded(headerFooterClass: UITableViewHeaderFooterView.Type) {
			let reuseIdentifier = headerFooterClass.reuseIdentifier
			guard !_registredHeaderFooterID.contains(reuseIdentifier) else { return }
			_registredHeaderFooterID.insert(reuseIdentifier)

			let view = _tableView?.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)
			guard view == nil else { return }

			if let nib = headerFooterClass.nib {
				_tableView?.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
				return
			}
			_tableView?.register(headerFooterClass, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
		}
	}
}
