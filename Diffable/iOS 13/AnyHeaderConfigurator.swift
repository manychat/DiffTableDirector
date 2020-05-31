//
//  AnyHeaderConfigurator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 31.05.2020.
//

import Foundation

struct AnyHeaderConfigurator: Hashable {
	static func == (lhs: AnyHeaderConfigurator, rhs: AnyHeaderConfigurator) -> Bool {
		return lhs.headerConfigurator.diffableItem.diffId == rhs.headerConfigurator.diffableItem.diffId
	}

	let headerConfigurator: HeaderConfigurator

	init(headerConfigurator: HeaderConfigurator) {
		self.headerConfigurator = headerConfigurator
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(headerConfigurator.diffableItem.diffableKeys)
		hasher.combine(headerConfigurator.diffableItem.diffId)
	}
}
