//
//  PaginationController.Loader.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

extension PaginationController {
	/// View and animator for pagination
	public struct Loader {
		let view: UIView
		let animator: PaginationControllerLoaderAnimator

		/// Default constructor
		/// - Parameters:
		///   - view: view that wil be shown when pagination is in progress, error and ect
		///   - animator: animate view
		public init(view: UIView, animator: PaginationControllerLoaderAnimator) {
			self.view = view
			self.animator = animator
		}

		public static var `deafult`: Loader {
			let width = UIScreen.main.bounds.width
			let background = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 40))
			let activityIndicator = UIActivityIndicatorView(style: .gray)
			background.addSubview(activityIndicator)
			activityIndicator.center = background.center
			let animator = DefaultAnimator(activityIndicator: activityIndicator)
			return Loader(view: background, animator: animator)
		}
	}
}

