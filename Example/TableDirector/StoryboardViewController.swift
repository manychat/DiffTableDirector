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
		}, additionalOffset: 83)

		feedModels = _loadFeed()
		infoModels = _loadInfo()

		let sections = self._createSections(
			feedModels: self.feedModels,
			infoModels: self.infoModels)
		self._tableDirector?.reload(
			with: sections,
			reloadRule: .calculateReloadAsync(queue: DispatchQueue.global()))
		
		let bottomPaginationController = PaginationController(
			settings: .bottom,
			loader: .deafult) { (handler) in
				DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
					handler.finished(isSuccessfull: false, canLoadNext: true)
				}
		}
		self._tableDirector?.add(paginationController: bottomPaginationController)

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
			let randomNumber = Double.random(in: Range(uncheckedBounds: (lower: 1, upper: 2)))
			return FeedModel(
				id: "\(index) \(randomNumber)",
				title: "Title \(index)",
				content: "Description",
				isMine: true)
		}
	}

	private func _loadInfo() -> [InfoModel] {
		return [
			.init(title: "Info Title", content: "Pressabe info cell"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 3", content: "Info content"),
			.init(title: "Info Title 4", content: "Info content"),
			.init(title: "Info Title 5", content: "Info content"),
			.init(title: "Info Title 6", content: "Info content"),
			.init(title: "Info Title 7", content: "Info content"),
			.init(title: "Info Title 8", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
			.init(title: "Info Title 2", content: "Info content"),
		]
	}

	// MARK: - Sections
	private func _createSections(feedModels: [FeedModel], infoModels: [InfoModel]) -> [TableSection] {
		let placeholderImage = UIImage(named: "placeholder")
		let infoRows = infoModels.map { (infoModel) -> TableActionRow<InfoCell> in
			return TableActionRow<InfoCell>(
				diffableModel: .init(
					diffId: UUID().uuidString,
					viewModel: .init(title: infoModel.title, content: infoModel.content)),
				delegate: self)
		}
		let infoHeader = TableHeader<TitleHeaderFooterView>(item: "Info")
		
		let feedRows = feedModels.map { (feedModel: FeedModel) -> TableRow<FeedCell> in
			return TableRow<FeedCell>(
				diffableModel: .init(
					diffId: feedModel.id,
					viewModel: .init(title: feedModel.title, content: feedModel.content, image: placeholderImage)))
		}

		return [TableSection(
			rows: (infoRows as [CellConfigurator] + feedRows as [CellConfigurator]).shuffled(), headerView: infoHeader),
				TableSection(
					rows: (infoRows as [CellConfigurator] + feedRows as [CellConfigurator]).shuffled())]
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
