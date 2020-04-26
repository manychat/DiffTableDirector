//
//  HeaderConfigurator.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 18.04.2020.
//

import UIKit

/// Configure Header with view model
public protocol HeaderConfigurator {
	var reuseId: String { get }
	func configure(view: UITableViewHeaderFooterView)
}

/// Configure Footer with view model
public typealias FooterConfigurator = HeaderConfigurator
