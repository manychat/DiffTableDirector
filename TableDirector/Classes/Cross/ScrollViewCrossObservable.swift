//
//  ScrollViewCrossObservable.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 04.05.2020.
//

import Foundation

protocol ScrollViewBoundsCrossObservable: class {
	var scrollView: UIScrollView { get }
	var boundsObserver: NSKeyValueObservation! { get }

	var overBottomBounds: Bool { get set }
	var overTopBounds: Bool { get set }

	var bottomThreshold: CGFloat { get }
	var topThreshold: CGFloat { get }

	var bottomCrossObserver: CrossObserver? { get set }
	var topCrossObserver: CrossObserver? { get set }
}
