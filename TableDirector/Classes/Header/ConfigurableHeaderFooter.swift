//
//  ConfigurableHeaderFooter.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 18.04.2020.
//

import Foundation

/// Can be configure with generic view model
public protocol ConfigurableHeaderFooter {
	associatedtype ViewModel

	func configure(_ item: ViewModel)
}
