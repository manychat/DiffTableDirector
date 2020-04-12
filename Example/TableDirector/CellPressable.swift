//
//  CellPressable.swift
//  TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

protocol CellPressableDelegate: class {
	func didPressedCell(_ cell: UITableViewCell)
}
