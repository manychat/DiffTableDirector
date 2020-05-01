//
//  TableDirector.CoverView.Position.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import UIKit

// MARK: - Position
extension TableDirector.CoverView {
	/// Information how to place view inside table view
	public enum Position {
		/// View in center of table view.
		/// - Parameters:
		///   - params: offset and height params for view
		///   - useAutolayout: settings to use autoLayout for view position. Default if true
		case center(params: CenterParams, useAutolayout: Bool = true)
		/// View inseted in table view
		/// - Parameters:
		///   - insets: insetes from bounds of table view
		///   - useAutolayout: settings to use autoLayout for view position. Default if true
		case insets(insets: UIEdgeInsets, useAutolayout: Bool = true)

		/// Position of view calculating from delegate each time bounds change
		/// - Parameters:
		///   - delegate: provides frame for view from current table view bounds
		case custom(delegate: TableDirectorCoverViewSizeDelegate)

		/// Center position with 16 offset from left and right side
		public static let `default`: TableDirector.CoverView.Position = .center(params: .init(leftOffset: 16))
	}
}

// MARK: - CenterParams
extension TableDirector.CoverView.Position {
	/// Position parameters for center option
	public struct CenterParams {
		let leftOffset: CGFloat
		let yCenterOffset: CGFloat
		let maxHeight: CGFloat

		/// Create center position info
		/// - Parameters:
		///   - leftOffset: offset from left side of table view
		///   - yCenterOffset: offset for center of view from center of table view bounds
		///   - maxHeight: maximum height for view. Default value is screen height
		public init(
			leftOffset: CGFloat,
			yCenterOffset: CGFloat = 0,
			maxHeight: CGFloat = UIScreen.main.bounds.height) {
			self.leftOffset = leftOffset
			self.yCenterOffset = yCenterOffset
			self.maxHeight = maxHeight
		}
	}
}
