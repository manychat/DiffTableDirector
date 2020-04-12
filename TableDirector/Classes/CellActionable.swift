//
//  CellActionable.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

// Separate protocol for cell with action. Remember 'I' from SOLID?
public protocol CellActionable: class {
	associatedtype Delegate
	var delegate: Delegate? { get set }
}
