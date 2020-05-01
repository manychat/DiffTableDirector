//
//  ErrorView.swift
//  Recoverable
//
//  Created by Aleksandr Lavrinenko on 02.02.2020.
//  Copyright © 2020 Aleksandr Lavrinenko. All rights reserved.
//

import UIKit

final class ErrorView: UIView {
	// MARK: - UI
	private let _titleLabel: UILabel = {
		let titleLabel = UILabel()
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		titleLabel.textAlignment = .center
		return titleLabel
	}()
	private let _descriptionLabel: UILabel = {
		let descriptionLabel = UILabel()
		descriptionLabel.font = UIFont.systemFont(ofSize: 16)
		descriptionLabel.textAlignment = .center
		return descriptionLabel
	}()
	private let _infoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	private let _buttonsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 8
		return stackView
	}()

	// MARK: - Lifecycle
	convenience init(title: String?, description: String?, actions: [ErrorView.Action]) {
		self.init(frame: .zero)

		_titleLabel.text = title
		_descriptionLabel.text = description
		actions.forEach { (action) in
			let button = RecoverableButton(touchUpInsideBlock: action.action)
			button.setTitle(action.title, for: .normal)
			button.touchUpInsideBlock = action.action
			button.translatesAutoresizingMaskIntoConstraints = false

			_setup(button: button)
			_buttonsStackView.addArrangedSubview(button)
		}
		_infoImageView.image = UIImage(named: "img_tech_work")
	}

	// MARK: - UIView
	override init(frame: CGRect) {
		super.init(frame: frame)
		_setupSubviews()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		_setupSubviews()
	}

	private func _setupSubviews() {
		addSubview(_titleLabel)
		addSubview(_descriptionLabel)
		addSubview(_infoImageView)
		addSubview(_buttonsStackView)

		_setupContraints()
	}

	private func _setup(button: UIButton) {
		button.backgroundColor = UIColor(red: 0, green: 0.497, blue: 0.96, alpha: 1)
		button.setTitleColor(.white, for: .normal)
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
	}

	// MARK: - Constraints
	private func _setupContraints() {
		[_infoImageView, _titleLabel, _descriptionLabel, _buttonsStackView]
			.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })

		_setupConstraints(imageView: _infoImageView, superview: self)
		_setupConstraints(titleLabel: _titleLabel, topView: _infoImageView, superview: self)
		_setupConstraints(descriptionLabel: _descriptionLabel, topView: _titleLabel, superview: self)
		_setupConstraints(buttonsStackView: _buttonsStackView, topView: _descriptionLabel, superview: self)
	}

	private func _setupConstraints(imageView: UIImageView, superview: UIView) {
		[
			imageView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 64),
			imageView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -64),
			imageView.topAnchor.constraint(equalTo: superview.topAnchor, constant: 16),
			imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
			].forEach({ $0.isActive = true })
	}

	private func _setupConstraints(titleLabel: UILabel, topView: UIView, superview: UIView) {
		[
			titleLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16),
			titleLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16)
			].forEach({ $0.isActive = true })
	}

	private func _setupConstraints(descriptionLabel: UILabel, topView: UIView, superview: UIView) {
		[
			descriptionLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
			descriptionLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16),
			descriptionLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
			].forEach({ $0.isActive = true })
	}

	private func _setupConstraints(buttonsStackView: UIStackView, topView: UIView, superview: UIView) {
		[
			buttonsStackView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
			buttonsStackView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16),
			buttonsStackView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16),
			buttonsStackView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -16),
			].forEach({ $0.isActive = true })
	}
}

extension ErrorView {
	struct Action {
		let title: String
		let action: (() -> Void)?
	}
}
