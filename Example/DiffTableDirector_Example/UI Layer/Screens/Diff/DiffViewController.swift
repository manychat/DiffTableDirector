//
//  DiffViewController.swift
//  DiffTableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.07.2020.
//  Copyright © 2020 Aleksandr Lavrinenko. All rights reserved.
//

import UIKit
import DiffTableDirector

final class DiffViewController: UIViewController {
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

	private var _feedModels: [FeedModel] = []

	private var _timer: Timer?

	// MARK: - Init
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)

		view.backgroundColor = .white
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

		_tableDirector = TableDirector(tableView: _tableView, reloadRule: .calculateReloadAsync(queue: .global()))

		_feedModels = _loadFeed()

		let rows = _createRows(feedModels: _feedModels)
		_tableDirector.reload(with: rows,  animation: .fade)

		_timer = Timer(fire: Date(), interval: 1.0, repeats: true, block: { [weak self] _ in
			guard let self = self else { return }
			let rows = self._createRows(feedModels: self._mix(feedModels: self._feedModels))
			self._tableDirector.reload(with: rows)
		})

		RunLoop.main.add(_timer!, forMode: .common)
	}

	func reload(tableDirector: TableDirectorInput, rows: [CellConfigurator]) {
		tableDirector.reload(with: rows, animation: .fade)
	}

	// MARK: - Fetch data
	private func _loadFeed() -> [FeedModel] {
		return (0..<80).map { (index)  in
			let randomNumber = Double.random(in: Range(uncheckedBounds: (lower: 1, upper: 1000)))
			return FeedModel(
				id: "\(randomNumber)",
				title: "Hi! I'm readonly cell №\(index)",
				content: "Some description",
				isMine: true)
		}
	}

	// MARK: - Helpers
	private func _createRows(feedModels: [FeedModel]) -> [CellConfigurator] {
		let placeholderImage = UIImage(named: "placeholder")
		let feedRows = feedModels.map { (feedModel: FeedModel) -> TableRow<FeedCell> in
			return TableRow<FeedCell>(
				viewModel: .init(
					diffID: feedModel.id,
					title: feedModel.title,
					content: feedModel.content,
					image: placeholderImage))
		}

		return feedRows
	}

	private func _mix(feedModels: [FeedModel]) -> [FeedModel] {
		var feedModels = feedModels
		(0..<2).forEach { randomIndex in
			let upperBound = feedModels.count
			let firstRandomNumber = Int.random(in: Range(uncheckedBounds: (lower: 0, upper: upperBound)))
			let secondRandomNumber = Int.random(in: Range(uncheckedBounds: (lower: 0, upper: upperBound)))
			feedModels.swapAt(firstRandomNumber, secondRandomNumber)
		}

		(0..<10).forEach { randomIndex in
			let upperBound = feedModels.count
			let randomNumber = Int.random(in: Range(uncheckedBounds: (lower: 0, upper: upperBound)))
			feedModels[randomNumber] = FeedModel(
				id: "\(randomNumber)",
				title: "Hi! I'm readonly cell №\(randomNumber)",
				content: "Some description",
				isMine: true)
		}

		return feedModels
	}
}
