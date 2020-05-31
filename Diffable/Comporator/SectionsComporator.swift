//
//  SectionsComporator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

struct SectionsComporator {
	@available(iOS 13.0, *)
	func calculateUpdate(newSections: [TableSection]) -> Snapshot {
		var snapshot = NSDiffableDataSourceSnapshot<AnyHeaderConfigurator, AnyCellConfigurator>()
		newSections.forEach { section in
			if let headerConfigurator = section.headerView {
				snapshot.appendSections([AnyHeaderConfigurator(headerConfigurator: headerConfigurator)])
			}
			snapshot.appendItems(section.rows.map { AnyCellConfigurator(cellConfigurator: $0) })
		}
		return snapshot
	}

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
			let comparator = RowsComparator<DiffInformation>(
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
