//
//  PaginationControllerLoaderAnimator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

/// Animate loader base on state
public protocol PaginationControllerLoaderAnimator {
	/// Animate loader base on state
	/// - Parameter state: loader state
	func animate(state: PaginationController.Loader.State)
}
