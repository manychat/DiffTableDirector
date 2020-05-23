//
//  LoadOperationHandable.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 10.05.2020.
//

import Foundation

/// Handle next page response
public protocol LoadOperationHandable {
	///
	/// - Parameters:
	///   - isSuccessfull: if operation was succesfull
	///   - canLoadNext: can paginate futher
	func finished(isSuccessfull: Bool, canLoadNext: Bool)
}
