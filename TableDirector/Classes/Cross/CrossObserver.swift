//
//  CrossObserver.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

public protocol CrossObserver {
	func scrollViewDidCrossBorder(scrollView: UIScrollView)
	func scrollViewDidReturnUnderBorder(scrollView: UIScrollView)
}

public struct SimpleCrossObserver {
	let didCross: () -> Void
	let didReturn: () -> Void
}

// MARK: - CrossObserver
extension SimpleCrossObserver: CrossObserver {
	public func scrollViewDidCrossBorder(scrollView: UIScrollView) {
		didCross()
	}

	public func scrollViewDidReturnUnderBorder(scrollView: UIScrollView) {
		didReturn()
	}
}
