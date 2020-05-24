//
//  PaginationController.Loader.State.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

extension PaginationController.Loader {
	/// Loader states
	public enum State {
		case initial
		case loading
		case error
		case success
	}
}
