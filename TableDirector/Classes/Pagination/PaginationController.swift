//
//  PaginationController.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

protocol PaginationControllerOutput: class {
	func scrollToThreshold(direction: PaginationController.Direction, offset: CGFloat)
	func changeTopContentInset(newOffset: CGFloat)
}

/// Trigger pagination, handle loading view states
public final class PaginationController {
	private let _loader: Loader
	private let _loadOperation: (LoadOperationHandable) -> Void

	private var _loading: Availability
	private var _scrollPosition: ScrollPosition
	private var _canStartLoading: Bool {
		guard _loading == .enabled else { return false }
		guard loadNext == .enabled else { return false }
		return true
	}

	let direction: Direction

	weak var output: PaginationControllerOutput?

	/// Avilability of next page
	public var loadNext: Availability

	/// Prefetch algorithm
	public var prefetch: PrefetchStrategy

	/// Scroll view behavior after getting error
	public var errorBehavior: ErrorBehavior

	/// Default constructor
	/// - Parameters:
	///   - settings: main settings
	///   - loader: view for loading and error process
	///   - operation: block that will load next data
	public init(
		settings: Settings,
		loader: Loader,
		operation: @escaping (LoadOperationHandable) -> Void) {
		self._loader = loader
		self._loadOperation = operation
		self._loading = .enabled
		self._scrollPosition = .aboveThreshold

		self.direction = settings.direction
		self.prefetch = settings.prefetch
		self.errorBehavior = settings.errorBehavior
		self.loadNext = settings.loadNext
	}

	func add(to tableView: UITableView) {
		if direction == .down {
			tableView.tableFooterView = _loader.view
			return
		}
		tableView.contentInset.top -= _loader.view.bounds.height
		tableView.tableHeaderView = _loader.view
	}

	func prefetchIfNeeded(tableView: UITableView, indexPaths: [IndexPath], sections: [TableSection]) {
		guard _canStartLoading else { return }

		switch prefetch {
		case .custom(let prefetchChecker):
			if prefetchChecker(tableView) {
				_startLoading()
			}
		case .base:
			_systemPrefetchIfNeeded(indexPaths: indexPaths, sections: sections)
		case .none:
			break
		}
	}

	private func _systemPrefetchIfNeeded(indexPaths: [IndexPath], sections: [TableSection]) {
		guard _canStartLoading else { return }
		guard let indexPath = _edgeIndexPath(from: indexPaths, direction: direction) else { return }
		let edgeLinearIndex = _lastRowLiniarIndex(in: Array(sections[0..<indexPath.section])) + indexPath.row
		let lastRowLineatIndex = _lastRowLiniarIndex(in: sections)
		guard abs(edgeLinearIndex - lastRowLineatIndex) < 2 else { return }
		_startLoading()
	}

	private func _handleLoaderStateChanges(newState: PaginationController.LoadResult) {
		_loading = .enabled
		switch newState {
		case .failure:
			_loader.animator.animate(state: .error)
			if direction == .up {
				output?.changeTopContentInset(newOffset: -_loader.view.bounds.height)
			}
			if errorBehavior == .scrollBack && _scrollPosition == .underThreshold {
				output?.scrollToThreshold(direction: direction, offset: additionalOffset)
			}
		case .success:
			_loader.animator.animate(state: .success)
		}
	}

	private func _startLoading() {
		_loading = .disabled
		_loader.animator.animate(state: .loading)
		_loadOperation(self)

		if direction == .up {
			output?.changeTopContentInset(newOffset: _loader.view.bounds.height)
		}
	}

	private func _edgeIndexPath(from indexPaths: [IndexPath], direction: Direction) -> IndexPath? {
		switch direction {
		case .up:
			return indexPaths.first
		case .down:
			return indexPaths.last
		}
	}

	private func _lastRowLiniarIndex(in sections: [TableSection]) -> Int {
		return sections.reduce(0, { $0 + $1.rows.count })
	}
}

// MARK: - ThresholdCrossObserver
extension PaginationController: ThresholdCrossObserver {
	public var additionalOffset: CGFloat {
		return -_loader.view.frame.height / 2
	}

	public func scrollViewDidCrossThreshold(scrollView: UIScrollView, offset: CGFloat) {
		_scrollPosition = .underThreshold
		guard _canStartLoading else { return }
		_startLoading()
	}

	public func scrollViewDidReturnUnderThreshold(scrollView: UIScrollView, offset: CGFloat) {
		_scrollPosition = .aboveThreshold
	}
}

// MARK: - LoadOperationHandable
extension PaginationController: LoadOperationHandable {
	public func finished(isSuccessfull: Bool, canLoadNext: Bool) {
		DispatchQueue.main.async {
			self._handleLoaderStateChanges(newState: isSuccessfull ? .success : .failure)
		}
		self.loadNext = canLoadNext ? .enabled : .disabled
	}
}
