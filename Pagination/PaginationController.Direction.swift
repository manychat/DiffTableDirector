//
//  PaginationController.Direction.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

extension PaginationController {
	/// Pagination direction
	public enum Direction {
		/// Paginate at the top from top. Mostly it is pull to refresh
		case up
		/// Paginate at the bottom
		case down
	}
}
