//
//  DropShadowViewController.swift
//  DiffTableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 15.07.2020.
//  Copyright © 2020 Aleksandr Lavrinenko. All rights reserved.
//

import Foundation
import DiffTableDirector

final class DropShadowViewController: UIViewController {
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

		view.backgroundColor = .white
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()

		view.addSubview(_tableView)
		_tableView.translatesAutoresizingMaskIntoConstraints = false

		[_tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
		 _tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		 _tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
		 _tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
			].forEach { $0.isActive = true }

		_tableDirector = TableDirector(tableView: _tableView)

		feedModels = _loadFeed()

		let rows = _createRows(feedModels: self.feedModels)
		self._tableDirector.reload(with: rows)

		_tableDirector.topCrossObserver = CrossObserver(didCross: { [weak self] in
			print("did cross top bound")
			self?.navigationController?.navigationBar.layer.shadowOpacity = 0
		}, didReturn: { [weak self] in
			if let navigationBar = self?.navigationController?.navigationBar {
				navigationBar.applyRasterizeShadow(
					offset: CGSize(width: 0, height: 1),
					radius: 1,
					opacity: 0.05)
			}
			}, offset: .value(offset: 1))

		_tableDirector.bottomCrossObserver = CrossObserver(didCross: {
			print("did cross bottom bound")
		}, didReturn: {
			print("did return in bound from bottom")
		}, offset: .value(offset: 83))
	}

	// MARK: - Fetch data
	private func _loadFeed() -> [FeedModel] {
		return (0..<80).map { (index)  in
			let randomNumber = Double.random(in: Range(uncheckedBounds: (lower: 1, upper: 1000)))
			return FeedModel(
				id: "\(index) \(randomNumber)",
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
}

extension UIView {
	func applyShadow(to layer: CALayer, rect: CGRect?, offset: CGSize, radius: CGFloat, opacity: Float) {
		if let rect = rect {
			layer.shadowPath =  UIBezierPath(ovalIn: rect).cgPath
		}
		layer.shadowOffset = offset
		layer.shadowRadius = radius
		layer.shadowOpacity = opacity
		layer.shadowColor = UIColor.black.cgColor
		layer.masksToBounds = false
	}

	func applyRasterizeShadow(offset: CGSize, radius: CGFloat, opacity: Float) {
		applyShadow(to: layer, rect: frame, offset: offset, radius: radius, opacity: opacity)
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	}
}
