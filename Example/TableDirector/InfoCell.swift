//
//  InfoCell.swift
//  TableDirector_Example
//
//  Created by Aleksandr Lavrinenko on 12.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TableDirector

final class InfoCell: UITableViewCell {
	// MARK: - UI
	private let _titleLabel = UILabel()
	private let _descriptionLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.numberOfLines = 0
		return titleLabel
	}()

	// MARK: - Properties
	weak var delegate: CellPressableDelegate?

	// MARK: - Init
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		contentView.addSubview(_titleLabel)
		_titleLabel.translatesAutoresizingMaskIntoConstraints = false
		[
			_titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			_titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
			_titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 16)
			].forEach { $0.isActive = true }

		contentView.addSubview(_descriptionLabel)
		_descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		[
			_descriptionLabel.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: -8),
			_descriptionLabel.leftAnchor.constraint(equalTo: _titleLabel.leftAnchor),
			_descriptionLabel.rightAnchor.constraint(equalTo: _titleLabel.rightAnchor),
			_descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			].forEach { $0.isActive = true }

		contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressedCell)))
	}

	@objc func didPressedCell() {
		delegate?.didPressedCell(self)
	}
}

// And every cell that we will use have to conform this
// MARK: - ConfigurableCell
extension InfoCell: ActionCell {
	typealias ViewModel = InfoViewModel
	typealias Delegate = CellPressableDelegate

	func configure(_ item: InfoViewModel) {
		// Fill your cell with data here
		_titleLabel.text = item.title
	}
}
