//
//  TableDirector.CoverView.ShowParams.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 03.05.2020.
//

import Foundation
import UIKit

extension TableDirector.CoverView {
	struct ShowParams {
		let coverView: UIView
		let position: TableDirector.CoverView.Position
		let showRule: TableDirector.EmptyViewShowRule
	}
}
