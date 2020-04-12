//
//  StoryboardViewController.swift
//  TableDirector
//
//  Created by aleksiosdev on 04/12/2020.
//  Copyright (c) 2020 aleksiosdev. All rights reserved.
//

import UIKit
import TableDirector

class StoryboardViewController: UIViewController {
	// MARK: - UI
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties
	private var _tableDirector: TableDirectorInput?
	var feedModels: [FeedModel] = []
	var infoModels: [InfoModel] = []

	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

		_tableDirector = TableDirector(tableView: tableView)
		_registerCells(in: tableView)

		feedModels = _loadFeed()
		infoModels = _loadInfo()

		let rows = _createRows(feedModels: feedModels, infoModels: infoModels)
		_tableDirector?.reload(with: rows)
    }

	private func _registerCells(in tableView: UITableView) {
		tableView.register(InfoCell.self, forCellReuseIdentifier: "InfoCell")
		tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
	}


	private func _loadFeed() -> [FeedModel] {
		return [
			.init(title: "Title", content: "Description", isMine: true)
		]
	}

	private func _loadInfo() -> [InfoModel] {
		return [
			.init(title: "Info Title", content: "Pressabe info cell"),
			.init(title: "Info Title 2", content: "Info content")
		]
	}

	private func _createRows(feedModels: [FeedModel], infoModels: [InfoModel]) -> [[CellConfigurator]] {
		let placeholderImage = UIImage(named: "placeholder")
		let infoRows = infoModels.map { (infoModel) in
			return TableActionRow<InfoCell>(item: .init(title: infoModel.title, content: infoModel.content), delegate: self)
		}
		let feedRows = feedModels.map { (feedModel: FeedModel) -> TableRow<FeedCell> in
			let viewModel = FeedViewModel(title: feedModel.title, content: feedModel.content, image: placeholderImage)
			return TableRow<FeedCell>(item: viewModel)
		}
		return [infoRows, feedRows]
	}
}

// MARK: - CellPressableDelegate
extension StoryboardViewController: CellPressableDelegate {
	func didPressedCell(_ cell: UITableViewCell) {
		guard let indexPath = _tableDirector?.indexPath(for: cell) else { return }
		let alertController = UIAlertController(title: "Did select", message: nil, preferredStyle: .alert)
		switch indexPath.section {
		case 0:
			alertController.message = "Model with title: \(infoModels[indexPath.row].title)"
		case 1:
			alertController.message = "Model with title: \(feedModels[indexPath.row].title)"
		default:
			break
		}
		alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}
