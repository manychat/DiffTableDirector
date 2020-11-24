//
//  StoryboardViewController.swift
//  DiffTableDirector
//
//  Created by aleksiosdev on 04/12/2020.
//  Copyright (c) 2020 aleksiosdev. All rights reserved.
//

import UIKit
import DiffTableDirector

class StoryboardViewController: UIViewController {
	// MARK: - UI
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Properties
	private var _tableDirector: TableDirectorInput?
	var feedModels: [FeedModel] = []
	var infoModels: [InfoModel] = []

	var timer: Timer!
	// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

		_tableDirector = TableDirector(tableView: tableView)
		_tableDirector?.topCrossObserver = CrossObserver(didCross: {
			print("did cross top bound")
		}, didReturn: {
			print("did return in bound from top")
		})

		_tableDirector?.bottomCrossObserver = CrossObserver(didCross: {
			print("did cross bottom bound")
		}, didReturn: {
			print("did return in bound from bottom")
		}, offset: .value(offset: 83))

		feedModels = _loadFeed()
		infoModels = _loadInfo()

		let sections = _createSections(feedModels: feedModels, infoModels: infoModels)
		self._tableDirector?.reload(with: sections)


		let topPaginationController = PaginationController(
			settings: .top,
			loader: .deafult) { (handler) in
				DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
					handler.finished(isSuccessfull: false, canLoadNext: false)
				}
		}
		self._tableDirector?.add(paginationController: topPaginationController)
    }

	// MARK: - Fetch data
	private func _loadFeed() -> [FeedModel] {
		return (0..<100).map { (index)  in
			let randomNumber = Double.random(in: Range(uncheckedBounds: (lower: 1, upper: 1000)))
			return FeedModel(
				id: "\(randomNumber)",
				title: "Hi! I'm readonly cell №\(index)",
				content: "Some description",
				isMine: true)
		}
	}

	private func _loadInfo() -> [InfoModel] {
		return [
			.init(title: "Info Title", content: "Pressabe info cell"),
			.init(title: "Hi! I'm action cell №2", content: "Info content"),
			.init(title: "Hi! I'm action cell №3", content: "Info content"),
			.init(title: "Hi! I'm action cell №4", content: "Info content"),
			.init(title: "Hi! I'm action cell №5", content: "Info content"),
			.init(title: "Hi! I'm action cell №6", content: "Info content"),
			.init(title: "Hi! I'm action cell №7", content: "Info content"),
			.init(title: "Hi! I'm action cell №8", content: "Info content"),
			.init(title: "Hi! I'm action cell №9", content: "Info content"),
			.init(title: "Hi! I'm action cell №10", content: "Info content"),
			.init(title: "Hi! I'm action cell №11", content: "Info content"),
			.init(title: "Hi! I'm action cell №12", content: "Info content"),
			.init(title: "Hi! I'm action cell №13", content: "Info content"),
			.init(title: "Hi! I'm action cell №14", content: "Info content"),
			.init(title: "Hi! I'm action cell №15", content: "Info content"),
			.init(title: "Hi! I'm action cell №16", content: "Info content"),
			.init(title: "Hi! I'm action cell №17", content: "Info content"),
			.init(title: "Hi! I'm action cell №18", content: "Info content"),
			.init(title: "Hi! I'm action cell №19", content: "Info content"),
			.init(title: "Hi! I'm action cell №20", content: "Info content"),
			.init(title: "Hi! I'm action cell №21", content: "Info content"),
			.init(title: "Hi! I'm action cell №22", content: "Info content"),
			.init(title: "Hi! I'm action cell №23", content: "Info content"),
			.init(title: "Hi! I'm action cell №24", content: "Info content"),
		]
	}

	// MARK: - Sections
	private func _createSections(feedModels: [FeedModel], infoModels: [InfoModel]) -> [TableSection] {
		let placeholderImage = UIImage(named: "placeholder")
		let infoRows = infoModels.map { (infoModel) -> TableActionRow<InfoCell> in
			return TableActionRow<InfoCell>(
				viewModel: .init(title: infoModel.title, content: infoModel.content),
				delegate: self)
		}
		let infoHeader = TableHeader<TitleHeaderFooterView>(viewModel: "Info")
		
		let feedRows = feedModels.map { (feedModel: FeedModel) -> TableRow<FeedCell> in
			return TableRow<FeedCell>(
				viewModel: .init(
					diffID: feedModel.id,
					title: feedModel.title,
					content: feedModel.content,
					image: placeholderImage))
		}

		return [TableSection(rows: infoRows, headerConfigurator: infoHeader),
				TableSection(rows: feedRows.shuffled())]
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
