//
//  DiffableCollection.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation
import DeepDiff

public protocol DiffableCollection: DiffAware {
	var diffId: String { get }

	static func compareContent(_ left: Self, _ right: Self) -> Bool
}
