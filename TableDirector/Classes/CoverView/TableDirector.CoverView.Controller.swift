//
//  TableDirector.CoverController.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import Foundation

extension TableDirector.CoverView {
	fileprivate typealias CenterParams = Position.CenterParams

	final class Controller {
		private weak var _activeView: UIView?
		private var _boundsObserver: NSKeyValueObservation?

		func add(view: UIView, to tableView: UITableView, position: TableDirector.CoverView.Position) {
			_activeView?.removeFromSuperview()
			_activeView = view

			tableView.addSubview(view)

			switch position {
			case .center(let params, let useAutoLayout):
				_layoutInCenter(view: view, to: tableView, params: params, useAutoLayout: useAutoLayout)
			case .insets(let insets, let useAutoLayout):
				_layoutWithInsets(view: view, to: tableView, insets: insets, useAutoLayout: useAutoLayout)
			case .custom(let delegate):
				_boundsObserver = tableView.observe(
					\.bounds,
					options: [.new, .initial],
					changeHandler: { [weak delegate, weak self] (_, change) in
						guard let newBounds = change.newValue else { return }
						guard let newFrame = delegate?.frame(for: newBounds.size) else { return }
						self?._activeView?.frame = newFrame
				})
			}
		}

		func hide() {
			_activeView?.removeFromSuperview()
		}

		// MARK: - Layout in center
		private func _layoutInCenter(view: UIView, to tableView: UITableView, params: CenterParams, useAutoLayout: Bool) {
			if useAutoLayout {
				return _layoutInCenterByConstraints(view: view, to: tableView, params: params)
			}
			_layoutInCenterByFrame(view: view, to: tableView, params: params)
		}

		private func _layoutInCenterByConstraints(view: UIView, to tableView: UIView, params: CenterParams) {
			view.translatesAutoresizingMaskIntoConstraints = false

			NSLayoutConstraint.activate([
				view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: params.leftOffset),
				view.heightAnchor.constraint(lessThanOrEqualToConstant: params.maxHeight),
				view.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
				view.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: params.yCenterOffset)
			])
		}

		private func _layoutInCenterByFrame(view: UIView, to tableView: UITableView, params: CenterParams) {
			let yCenter = tableView.bounds.height / 2
			let xCenter = tableView.bounds.width / 2
			let center = CGPoint(x: xCenter, y: yCenter + params.yCenterOffset)
			view.center = center

			let width = tableView.bounds.width - 2 * params.leftOffset
			view.frame.size.width = width
			view.frame.size.height = params.maxHeight
		}

		// MARK: - Layout by insets
		private func _layoutWithInsets(view: UIView, to tableView: UITableView, insets: UIEdgeInsets, useAutoLayout: Bool) {
			if useAutoLayout {
				return _layoutWithInsetsByConstraints(view: view, to: tableView, insets: insets)
			}
			_layoutWithInsetsByFrame(view: view, to: tableView, insets: insets)
		}

		private func _layoutWithInsetsByConstraints(view: UIView, to tableView: UIView, insets: UIEdgeInsets) {
			view.translatesAutoresizingMaskIntoConstraints = false

			NSLayoutConstraint.activate([
				view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: insets.left),
				view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -insets.right),
				view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: insets.top),
				view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -insets.bottom)
			])
		}

		private func _layoutWithInsetsByFrame(view: UIView, to tableView: UITableView, insets: UIEdgeInsets) {
			let frame = CGRect(origin: .zero, size: tableView.bounds.size).inset(by: insets)
			view.frame = frame
		}
	}
}
