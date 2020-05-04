//
//  CrossObserver.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

/// Handle cross events in scroll view
public protocol ThresholdCrossObserver {
	/// Offset from base bound border
	var additionalOffset: CGFloat { get }

	/// Did cross top thresold
	/// - Parameters:
	///   - scrollView: scroll view
	///   - offset: scroll view offset
	func scrollViewDidCrossThreshold(scrollView: UIScrollView, offset: CGFloat)

	/// Did return under thresold
	/// - Parameters:
	///   - scrollView: scroll view
	///   - offset: scroll view offset
	func scrollViewDidReturnUnderThreshold(scrollView: UIScrollView, offset: CGFloat)
}
