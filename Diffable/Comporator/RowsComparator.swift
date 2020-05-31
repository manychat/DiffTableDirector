//
//  RowComparator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation
import DeepDiff

struct RowsComparator<T: DiffableCollection> {
	let deleted: [IndexPath]
	let inserted: [IndexPath]
	let moved: [(from: IndexPath, to: IndexPath)]
	let replaced: [IndexPath]

	init(old: [T], new: [T], section: Int) {
		let changes = diff(old: old, new: new)
		deleted = changes.compactMap({ (change) -> IndexPath? in
			return change.delete.map({ IndexPath(row: $0.index, section: section) })
		})

		inserted = changes.compactMap({ (change) -> IndexPath? in
			change.insert.map({ IndexPath(row: $0.index, section: section) })
		})

		moved = changes.compactMap({ (change) -> (IndexPath, IndexPath)? in
			return change.move
				.map({  (IndexPath(row: $0.fromIndex, section: section), IndexPath(row: $0.toIndex, section: section)) })
		})

		replaced = changes.compactMap({ (change) -> IndexPath? in
			return change.replace.map({ IndexPath(row: $0.index, section: section) })
		})
	}
}
