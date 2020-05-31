//
//  DiffableDataSource.swift
//  DeepDiff
//
//  Created by Aleksandr Lavrinenko on 30.05.2020.
//

import Foundation

protocol DiffableDataSource {	
	func apply(snapshot: Snapshot)
}
