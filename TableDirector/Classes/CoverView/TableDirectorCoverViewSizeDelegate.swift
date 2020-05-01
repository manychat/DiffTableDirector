//
//  TableDirectorCoverViewSizeDelegate.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

/// Provide frame for cover view from talbe view bound size
public protocol TableDirectorCoverViewSizeDelegate: class {
	/// Provide frame for cover view from talbe view bound size
	/// - Parameter containerSize: bounds size of table view
	func frame(for containerSize: CGSize) -> CGRect
}
