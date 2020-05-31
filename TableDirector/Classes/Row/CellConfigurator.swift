//
//  CellConfigurator.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Interface for every 
public protocol CellConfigurator {
	var cellClass: UITableViewCell.Type { get }
	var diffableItem: DiffInformation { get }

	func configure(cell: UITableViewCell)
}
