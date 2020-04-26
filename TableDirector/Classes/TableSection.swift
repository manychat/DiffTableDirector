//
//  TableSection.swift
//  Pods-TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 18.04.2020.
//

import Foundation

/// Store configurators to create single section
public final class TableSection {
	let headerView: HeaderConfigurator?
	let footerView: FooterConfigurator?
	let rows: [CellConfigurator]

	public init(
		rows: [CellConfigurator],
		headerView: HeaderConfigurator? = nil,
		footerView: FooterConfigurator? = nil) {
		self.headerView = headerView
		self.footerView = footerView
		self.rows = rows
	}

	var isEmpty: Bool {
		return rows.isEmpty
	}
}
