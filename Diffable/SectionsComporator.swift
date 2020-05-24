//
//  SectionsComporator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

struct SectionsComporator {
	func calculateUpdate(oldSections: [TableSection], newSections: [TableSection]) -> CollectionUpdate {
		let sectionsDiff = newSections.count - oldSections.count

		let insertedSections: IndexSet? = sectionsDiff > 0 ?
			IndexSet((0..<sectionsDiff).map({ $0 + oldSections.count })) : nil
		let deletedSections: IndexSet? = sectionsDiff < 0 ?
			IndexSet((0..<abs(sectionsDiff)).map({ $0 + newSections.count })) : nil

		var insertedIndexes: [IndexPath] = []
		var deletedIndexes: [IndexPath] = []
		var reloadedIndexes: [IndexPath] = []
		for (index, section) in newSections.enumerated() {
			guard let oldSection = oldSections[safe: index] else {
				continue
			}
			let comparator = RowsComparator<DiffableItem>(
				old: oldSection.rows.map({ $0.diffableItem }),
				new: section.rows.map({ $0.diffableItem }),
				section: index)
			insertedIndexes += comparator.inserted
			deletedIndexes += comparator.deleted
			reloadedIndexes += comparator.replaced
		}
		return CollectionUpdate(
			reload: .init(rows: reloadedIndexes),
			insert: .init(rows: insertedIndexes, sections: insertedSections),
			delete: .init(rows: deletedIndexes, sections: deletedSections))
	}
}
