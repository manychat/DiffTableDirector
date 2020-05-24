//
//  CollectionUpdate.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

struct CollectionUpdate {
	let reload: Batch
	let insert: Batch
	let delete: Batch

	static let zero = CollectionUpdate()

	init(
		reload: Batch = .zero,
		insert: Batch = .zero,
		delete: Batch = .zero) {
		self.reload = reload
		self.insert = insert
		self.delete = delete
	}

	var isEmpty: Bool {
		if reload == .zero,
			insert == .zero,
			delete == .zero {
			return true
		}
		return false
	}
}
