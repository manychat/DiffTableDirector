//
//  PaginationController.ErrorBehavior.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 23.05.2020.
//

import Foundation

extension PaginationController {
	/// Scroll view behaviour after getting error
	public enum ErrorBehavior {
		/// Like it said - do nothing
		case doNothing
		/// Scroll back to original table view content
		case scrollBack
	}
}
