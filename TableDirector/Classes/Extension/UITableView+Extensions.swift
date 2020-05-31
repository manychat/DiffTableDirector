//
//  UITableView+Extensions.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import UIKit

extension UITableView {
	private func _insertSection(update: CollectionUpdate) {
		if update.insert != .zero {
			if let sections = update.insert.sections {
				self.insertSections(sections, with: .none)
			}
			self.insertRows(at: update.insert.rows, with: .none)
		}
	}

	private func _deleteSection(update: CollectionUpdate) {
		if update.delete != .zero {
			if let sections = update.delete.sections {
				self.deleteSections(sections, with: .none)
			}
			self.deleteRows(at: update.delete.rows, with: .none)
		}
	}

	private func _reloadSection(update: CollectionUpdate) {
		if update.reload != .zero {
			if let sections = update.reload.sections {
				self.reloadSections(sections, with: .none)
			}
			self.reloadRows(at: update.reload.rows, with: .none)
		}
	}

	func reload(
		update: CollectionUpdate,
		animated: Bool,
		updateSectionsBlock: @escaping () -> Void,
		completion: (() -> Void)?) {
		DispatchQueue.asyncOnMainIfNeeded { [update] in
			UIView.setAnimationsEnabled(animated)
			if #available(iOS 11.0, *) {
				self.performBatchUpdates({
					updateSectionsBlock()
					self._insertSection(update: update)
					self._deleteSection(update: update)
				}, completion: { _ in
					self.performBatchUpdates({
						self._reloadSection(update: update)
					}, completion: { _ in
						completion?()
						UIView.setAnimationsEnabled(animated)
					})
				})
			} else {
				fatalError()
			}
		}
	}
}

extension DispatchQueue {
	static func asyncOnMainIfNeeded(_ callback: @escaping () -> Void) {
		if Thread.current.isMainThread {
			callback()
		} else {
			DispatchQueue.main.async {
				callback()
			}
		}
	}
}
