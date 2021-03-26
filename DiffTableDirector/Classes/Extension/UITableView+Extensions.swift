//
//  UITableView+Extensions.swift
//  TableDirector
//
//  Created by Aleksandr Lavrinenko on 24.05.2020.
//

import UIKit

extension UITableView {
	private func _insertSection(update: CollectionUpdate, animation: UITableView.RowAnimation) {
		if update.insert != .zero {
			if let sections = update.insert.sections {
				self.insertSections(sections, with: animation)
			}
			self.insertRows(at: update.insert.rows, with: animation)
		}
	}

	private func _deleteSection(update: CollectionUpdate, animation: UITableView.RowAnimation) {
		if update.delete != .zero {
			if let sections = update.delete.sections {
				self.deleteSections(sections, with: animation)
			}
			self.deleteRows(at: update.delete.rows, with: animation)
		}
	}

	private func _reloadSection(update: CollectionUpdate, animation: UITableView.RowAnimation) {
		if update.reload != .zero {
			if let sections = update.reload.sections {
				self.reloadSections(sections, with: animation)
			}
			self.reloadRows(at: update.reload.rows, with: animation)
		}
	}

	private func _moveSections(update: CollectionUpdate, animation: UITableView.RowAnimation) {
		if update.move != .zero {
			update.move.rows.forEach {
				self.moveRow(at: $0.from, to: $0.to)
			}
		}
	}

	func reload(
		update: CollectionUpdate,
		animation: UITableView.RowAnimation,
		updateSectionsBlock: @escaping () -> Void,
		completion: @escaping () -> Void) {
		DispatchQueue.asyncOnMainIfNeeded { [update] in
			UIView.setAnimationsEnabled(animation.enabled)
			if #available(iOS 11.0, *) {
				self.performBatchUpdates({ [weak self] in
					updateSectionsBlock()
					self?._insertSection(update: update, animation: animation)
					self?._deleteSection(update: update, animation: animation)
				}, completion: { _ in
					self.performBatchUpdates({  [weak self] in
						self?._reloadSection(update: update, animation: animation)
						self?._moveSections(update: update, animation: animation)
					}, completion: { _ in
						UIView.setAnimationsEnabled(true)
						completion()
					})
				})
			} else {
				fatalError()
			}
		}
	}

	func fullReload(completion: @escaping () -> Void) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		reloadData()
		CATransaction.commit()
	}
}
