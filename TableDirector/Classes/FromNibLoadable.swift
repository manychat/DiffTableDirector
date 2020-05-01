//
//  FromNibLoadableView.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import UIKit

/// View can provide nib. Default implementation accesable for view with support of ReusableView
public protocol FromNibLoadable: UIView {
	/// Try to get nib with the nib name
	static var nib: UINib? { get }

	/// Nib name. If view support ReusableView default name will be reuseIdentifier
	static var nibName: String { get }
}

// MARK: - Default implementation for ReusableView
public extension FromNibLoadable where Self: ReusableView {
	static var nibName: String {
		return reuseIdentifier
	}

	static var nib: UINib? {
		let bundle = Bundle(for: self)
		// Check if we have nib with nibName.
		// Attempt to create nonexisten nib by UINib(nibName... will lead to crash in runtime
		guard bundle.path(forResource: nibName, ofType: "nib") != nil else { return nil }
		return UINib(nibName: nibName, bundle: bundle)
	}
}
