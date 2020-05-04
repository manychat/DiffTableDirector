//
//  CrossObserver.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

public struct CrossObserver {
	public let didCross: () -> Void
	public let didReturn: () -> Void
	public let additionalOffset: CGFloat

	public init(didCross: @escaping () -> Void, didReturn: @escaping () -> Void, additionalOffset: CGFloat = 0) {
		self.didCross = didCross
		self.didReturn = didReturn

		self.additionalOffset = additionalOffset
	}
}

// MARK: - ThresholdCrossObserver
extension CrossObserver: ThresholdCrossObserver {
	public func scrollViewDidCrossThreshold(scrollView: UIScrollView, offset: CGFloat) {
		didCross()
	}

	public func scrollViewDidReturnUnderThreshold(scrollView: UIScrollView, offset: CGFloat) {
		didReturn()
	}
}
