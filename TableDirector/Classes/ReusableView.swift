//
//  ReusableCell.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Provide reuse identifier for reusability
public protocol ReusableView {
	static var reuseIdentifier: String { get }
}

/// Default implementation
public extension ReusableView {
	static var reuseIdentifier: String {
		return String(describing: self)
	}
}
