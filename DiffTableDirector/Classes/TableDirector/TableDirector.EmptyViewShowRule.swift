//
//  TableDirector.CoverView.Position.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import UIKit

// MARK: - Position
public extension TableDirector {
	/// When cover view should be shown
	enum EmptyViewShowRule {
		// When there is no cells
		case noCells
		// When caller decide if cover view should be shown
		case custom(rule: (_ sections: [TableSection]) -> Bool)
	}
}
