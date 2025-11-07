//
//  ViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let exploreButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Title label
        titleLabel.text = "Welcome to OffWorld 🌍"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Button
        exploreButton.setTitle("Explore OffWorld", for: .normal)
        exploreButton.backgroundColor = .systemBlue
        exploreButton.setTitleColor(.white, for: .normal)
        exploreButton.layer.cornerRadius = 12
        exploreButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        exploreButton.addTarget(self, action: #selector(exploreTapped), for: .touchUpInside)

        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(exploreButton)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            exploreButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            exploreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exploreButton.widthAnchor.constraint(equalToConstant: 220),
            exploreButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    // MARK: - Actions
    @objc private func exploreTapped() {
        let homeVC = MainHomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
}
