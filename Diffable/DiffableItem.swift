//
//  DiffableItem.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

public struct DiffableItem: DiffableCollection {
	public let diffId: String
	let diffableKeys: [String: String]

	public static func compareContent(_ left: Self, _ right: Self) -> Bool {
		return left.diffableKeys == right.diffableKeys
	}

	static var randomItem: DiffableItem {
		let diffId = UUID().uuidString
		return DiffableItem(diffId: diffId, diffableKeys: [:])
	}
}
