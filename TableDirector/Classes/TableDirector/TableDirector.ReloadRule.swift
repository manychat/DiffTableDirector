//
//  TableDirector.ReloadRule.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import Foundation

extension TableDirector {
	/// How update table
	public enum ReloadRule {
		/// User table view reloadData method. Perfom full reload
		case fullReload
		/// Calculate diff on main thread, reload updated cells
		case calculateReloadSync
		/// Calculate diff on background thread, reload updated cells
		case calculateReloadAsync
	}
}
