//
//  CollectionUpdate.Update.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

// MARK: - Batch
extension CollectionUpdate {
	struct Batch {
		let rows: [IndexPath]
		let sections: IndexSet?

		static let zero = CollectionUpdate.Batch(rows: [], sections: nil)

		var description: String {
			return "rows: \(rows) sections: \(String(describing: sections))"
		}

		init(rows: [IndexPath], sections: IndexSet? = nil) {
			self.rows = rows
			self.sections = sections
		}
	}
}

// MARK: - Equatable
extension CollectionUpdate.Batch: Equatable { }
