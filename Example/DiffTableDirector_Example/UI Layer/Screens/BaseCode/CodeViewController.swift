//
//  CodeViewController.swift
//  TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import DiffTableDirector

class CodeViewController: UIViewController {
	// MARK: - UI
	private let _tableView: UITableView = {
		let tableView = UITableView()
		tableView.separatorStyle = .none
		return tableView
	}()

	// MARK: - Properties
	private lazy var _tableDirector: TableDirectorInput = {
		return TableDirector(tableView: _tableView)
	}()

	var feedModels: [FeedModel] = []
	var infoModels: [InfoModel] = []

	// MARK: - Init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(_tableView)
		_tableView.translatesAutoresizingMaskIntoConstraints = false
		
		[_tableView.topAnchor.constraint(equalTo: view.topAnchor),
			_tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			_tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			_tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			].forEach { $0.isActive = true }

		feedModels = self._loadFeed()
		infoModels = self._loadInfo()

		let sections = self._createSections(feedModels: self.feedModels, infoModels: self.infoModels)
		_tableDirector.reload(with: sections, animation: .fade)
	}


	private func _loadFeed() -> [FeedModel] {
		return [
			.init(id: "1", title: "Hi! I'm readonly cell", content: "Some description", isMine: true)
		]
	}

	private func _loadInfo() -> [InfoModel] {
		return [
			.init(title: "Hi! I'm action cell №1", content: "Press me to get alert with my title"),
			.init(title: "Hi! I'm action cell №2", content: "Press me to get alert with my title")
		]
	}

	private func _createSections(feedModels: [FeedModel], infoModels: [InfoModel]) -> [TableSection] {
		let placeholderImage = UIImage(named: "placeholder")
		let infoRows = infoModels.map { (infoModel) in
			return TableActionRow<InfoCell>(viewModel: .init(title: infoModel.title, content: infoModel.content), delegate: self)
		}
		let infoHeader = TableHeader<TitleHeaderFooterView>(viewModel: "Action cell section")

		let feedRows = feedModels.map { (feedModel: FeedModel) -> TableRow<FeedCell> in
			let viewModel = FeedViewModel(
				diffID: feedModel.id,
				title: feedModel.title,
				content: feedModel.content,
				image: placeholderImage)
			return TableRow<FeedCell>(viewModel: viewModel)
		}
		return [TableSection(rows: infoRows, headerConfigurator: infoHeader), TableSection(rows: feedRows)]
	}
}

// MARK: - CellPressableDelegate
extension CodeViewController: CellPressableDelegate {
	func didPressedCell(_ cell: UITableViewCell) {
		guard let indexPath = _tableDirector.indexPath(for: cell) else { return }
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
