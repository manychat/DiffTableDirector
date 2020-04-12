//
//  UITableViewCell+Extension.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//

import Foundation

extension UITableViewCell {
	/// Return reuseIdentifier for UITableViewCell from class name
	///
	/// - Returns: reuseIdentifier
	static var reuseIdentifier: String {
		return String(String(describing: self.self).split(separator: ".").last!)
	}
}
