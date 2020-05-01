//
//  TableItemActionable.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

/// Separate protocol for cell with action. Remember 'I' from SOLID?
public protocol TableItemActionable: class {
	associatedtype Delegate
	var delegate: Delegate? { get set }
}
