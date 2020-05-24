//
//  PaginationController.Settings.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 23.05.2020.
//

import Foundation

extension PaginationController {
	public struct Settings {
		/// Paginatiom direction
		public let direction: Direction

		/// How prefetch should work
		public let prefetch: PrefetchStrategy

		/// Scroll view behavior after getting error
		public let errorBehavior: ErrorBehavior

		/// Avilability of next page
		public let loadNext: Availability

		/// Create setttings for pagination controller.
		/// For pull to reftesh at the top we reccomend disable prefetch
		/// - Parameters:
		///   - direction: pagination direction
		///   - prefetch: prefetch algorithm
		///   - errorBehavior: scroll view behavior after getting error
		///   - loadNext: avilability of next page
		public init(
			direction: Direction,
			prefetch: PrefetchStrategy,
			errorBehavior: ErrorBehavior = .scrollBack,
			loadNext: Availability = .enabled) {
			self.direction = direction
			self.prefetch = prefetch
			self.errorBehavior = errorBehavior
			self.loadNext = loadNext
		}

		/// Default setting for bottom pagination
		public static let bottom: Settings = .init(direction: .down, prefetch: .base)

		/// Default settings for top pull to refresh
		public static let top: Settings = .init(direction: .up, prefetch: .none)
	}
}
