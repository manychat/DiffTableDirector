//
//  DiffableViewModel.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

public protocol DiffableViewModel {
	var diffableKeys: [String: String] { get }
}

extension DiffableViewModel {
	var diffableKeys: [String: String] {
		let mirrow = Mirror(reflecting: self)
		return mirrow.children.reduce([:], { result, property in
			guard let label = property.label else { return result }
			var result = result
			result[label] = "\(property.value)"
			return result
		})
	}
}
