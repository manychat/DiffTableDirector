//
//  PaginationController.Loader.DefaultAnimator.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

extension PaginationController.Loader {
	struct DefaultAnimator {
		private weak var _activityIndicator: UIActivityIndicatorView?

		init(activityIndicator: UIActivityIndicatorView) {
			self._activityIndicator = activityIndicator
			self._activityIndicator?.isHidden = true
		}
	}
}

// MARK: - PaginationControllerLoaderAnimator
extension PaginationController.Loader.DefaultAnimator: PaginationControllerLoaderAnimator {
	func animate(state: PaginationController.Loader.State) {
		switch state {
		case .loading:
			_activityIndicator?.isHidden = false
			_activityIndicator?.startAnimating()
		case .success,
			 .error,
			 .initial:
			_activityIndicator?.stopAnimating()
			_activityIndicator?.isHidden = true
		}
	}
}
