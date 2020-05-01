//
//  TableActionHeader.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 01.05.2020.
//

import Foundation

public final class TableActionHeader<HeaderType: ActionHeader>: HeaderConfigurator
where HeaderType: UITableViewHeaderFooterView {
	public var viewClass: UITableViewHeaderFooterView.Type { return HeaderType.self }

	var item: HeaderType.ViewModel
	// Delegate must be weak or we gonna have big memory issue
	weak var delegate: AnyObject?

	// Store item and delegate
	public  init(item: HeaderType.ViewModel, delegate: HeaderType.Delegate) {
		self.item = item
		// Here is some hack that I'll expalin under code
		self.delegate = delegate as AnyObject
	}

	public func configure(view: UITableViewHeaderFooterView) {
		guard let viewWithType = view as? HeaderType else {
			fatalError()
		}
		viewWithType.configure(item)
		// Put Delegate inside
		viewWithType.delegate = delegate as? HeaderType.Delegate
	}
}
