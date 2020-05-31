//
//  FeedViewModel.swift
//  TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TableDirector

struct FeedViewModel: DiffableViewModel {
	let title: String
	let content: String
	let image: UIImage?
}
