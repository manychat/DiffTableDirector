//
//  BaseThresholdCalculator.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 05.05.2020.
//

import Foundation

struct BaseThresholdCalculator {
	func calculateBaseTopThreshold(for scrollView: UIScrollView) -> CGFloat {
		return scrollView.contentInset.top
	}

	func calculateBaseBottomThreshold(for scrollView: UIScrollView) -> CGFloat {
		return  scrollView.contentSize.height - scrollView.frame.height + scrollView.contentInset.bottom
	}
}
