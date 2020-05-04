//
//  ScrollViewBoundsCrossObserver.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

final class ScrollViewBoundsCrossObserver {
	let scrollView: UIScrollView
	private(set) var boundsObserver: NSKeyValueObservation!

	var overBottomBounds: Bool = false
	var overTopBounds: Bool = false

	var bottomThreshold: CGFloat
	var topThreshold: CGFloat

	var bottomCrossObserver: CrossObserver?
	var topCrossObserver: CrossObserver?

	init(scrollView: UIScrollView) {
		self.scrollView = scrollView

		self.bottomThreshold = scrollView.contentSize.height -
			scrollView.frame.height +
			scrollView.contentInset.bottom
		self.topThreshold = scrollView.contentInset.top + 1

		self.boundsObserver = scrollView.createScrollObserver { [weak self] (point) in
			self?._checkTopBound(for: point.y)
			self?._checkBottomBound(for: point.y)
		}
	}

	private func _checkTopBound(for newY: CGFloat) {
		if !overTopBounds && newY > topThreshold {
			overTopBounds = true
			topCrossObserver?.scrollViewDidCrossBorder(scrollView: scrollView)
		}
		if overTopBounds && newY < topThreshold {
			overTopBounds = false
			topCrossObserver?.scrollViewDidReturnUnderBorder(scrollView: scrollView)
		}
	}

	private func _checkBottomBound(for newY: CGFloat) {
		if newY > bottomThreshold && !overBottomBounds {
			bottomCrossObserver?.scrollViewDidCrossBorder(scrollView: scrollView)
			overBottomBounds = true
		}
		if overBottomBounds && newY <= bottomThreshold && newY > topThreshold {
			overBottomBounds = false
			bottomCrossObserver?.scrollViewDidReturnUnderBorder(scrollView: scrollView)
		}
	}
}

// MARK: - ScrollViewBoundsCrossObservable
extension ScrollViewBoundsCrossObserver: ScrollViewBoundsCrossObservable { }

extension UIScrollView {
	func createScrollObserver(hanlder: @escaping ((CGPoint) -> Void)) -> NSKeyValueObservation {
		return observe(\UIScrollView.contentOffset, options: [.new]) { (_, changes) in
			guard let newValue = changes.newValue else { return }
			hanlder(newValue)
		}
	}
}
