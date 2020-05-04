//
//  ScrollViewCrossObservable.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

protocol ScrollViewBoundsCrossObservable: class {
	var scrollView: UIScrollView { get }

	var overBottomBounds: Bool { get set }
	var overTopBounds: Bool { get set }

	var bottomThreshold: CGFloat { get }
	var topThreshold: CGFloat { get }

	var bottomCrossObserver: ThresholdCrossObserver? { get set }
	var topCrossObserver: ThresholdCrossObserver? { get set }

	func createContentOffsetObserver() -> NSKeyValueObservation
	func checkTopBound(for newY: CGFloat)
	func checkBottomBound(for newY: CGFloat)
}

// MARK: - Default implementation
extension ScrollViewBoundsCrossObservable {
	func createContentOffsetObserver() -> NSKeyValueObservation {
		scrollView.createScrollObserver { [weak self] (point) in
			self?.checkTopBound(for: point.y)
			self?.checkBottomBound(for: point.y)
		}
	}

	func checkTopBound(for newY: CGFloat) {
		if !overTopBounds && newY < topThreshold {
			overTopBounds = true
			topCrossObserver?.scrollViewDidCrossThreshold(scrollView: scrollView, offset: newY)
		}
		if overTopBounds && newY >= topThreshold {
			overTopBounds = false
			topCrossObserver?.scrollViewDidReturnUnderThreshold(scrollView: scrollView, offset: newY)
		}
	}

	func checkBottomBound(for newY: CGFloat) {
		if newY > bottomThreshold && !overBottomBounds {
			bottomCrossObserver?.scrollViewDidCrossThreshold(scrollView: scrollView, offset: newY)
			overBottomBounds = true
		}
		if overBottomBounds && newY <= bottomThreshold && newY > topThreshold {
			overBottomBounds = false
			bottomCrossObserver?.scrollViewDidReturnUnderThreshold(scrollView: scrollView, offset: newY)
		}
	}
}
