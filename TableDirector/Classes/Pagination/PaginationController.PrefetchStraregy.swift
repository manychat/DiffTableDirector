//
//  PaginationController.PrefetchStraregy.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 23.05.2020.
//

import Foundation

extension PaginationController {
	/// Prefet
	public enum PrefetchStrategy {
		/// No prefetching
		case none
		/// Use apple prefetch algorithm. If it provides last cell in table - we prefetch
		case base
		/// Custom function calculate if we should prefetch
		case custom((UITableView) -> Bool)
	}
}
