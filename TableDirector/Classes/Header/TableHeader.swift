//
//  TableHeader.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 18.04.2020.
//

import Foundation

/// Configure provided header with view model
public class TableHeader<HeaderType: ConfigurableHeaderFooter>: HeaderConfigurator
where HeaderType: UITableViewHeaderFooterView {
	public var viewClass: UITableViewHeaderFooterView.Type { return HeaderType.self }

	public private(set) var diffableItem: DiffInformation = .randomItem
	let item: HeaderType.ViewModel

	public init(item: HeaderType.ViewModel) {
		self.item = item
	}

	public func configure(view: UITableViewHeaderFooterView) {
		guard let viewWithType = view as? HeaderType else {
			fatalError()
		}
		viewWithType.configure(item)
	}
}

//// MARK: - CellType.ViewModel: Equatable
//extension TableHeader where HeaderType.ViewModel: DiffableViewModel {
//	public convenience init(diffableModel: DiffableModel<HeaderType>) {
//		self.init(item: diffableModel.viewModel)
//		diffableItem = diffableModel.diffableItem
//	}
//}

