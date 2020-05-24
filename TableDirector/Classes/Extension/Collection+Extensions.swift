//
//  Collection+Extensions.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

extension Collection {
	subscript(safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}
