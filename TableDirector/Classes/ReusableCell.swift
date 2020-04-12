//
//  ReusableCell.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Provide reuse identifier for reusability
public protocol ReusableCell {
	static var reuseIdentifier: String { get }
}

// Default implementation
public extension ReusableCell {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}
