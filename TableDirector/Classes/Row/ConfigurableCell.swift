//
//  ConfigurableCell.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Cell can be filled with specific ViewModel
public protocol ConfigurableCell: class {
	associatedtype ViewModel

	func configure(_ item: ViewModel)
}
