//
//  AccountTypeViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/24/25.
//

import UIKit

final class AccountTypeViewController: UIViewController {

    private let titleLabel = UILabel()
    private let businessButton = UIButton(type: .system)
    private let individualButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Who Are You?"
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Choose Your Account Type"
        titleLabel.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        [businessButton, individualButton].forEach {
            $0.backgroundColor = .systemBlue
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        businessButton.setTitle("Business", for: .normal)
        individualButton.setTitle("Individual", for: .normal)

        businessButton.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)
        individualButton.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            businessButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            businessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessButton.widthAnchor.constraint(equalToConstant: 250),
            businessButton.heightAnchor.constraint(equalToConstant: 55),

            individualButton.topAnchor.constraint(equalTo: businessButton.bottomAnchor, constant: 30),
            individualButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            individualButton.widthAnchor.constraint(equalToConstant: 250),
            individualButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    @objc private func handleSelection(_ sender: UIButton) {
        let selectedType = sender.currentTitle ?? "Individual"

        // ✅ Save to UserDefaults
        UserDefaults.standard.set(selectedType, forKey: "accountType")

        // Navigate to main page
        let mainVC = MainHomeViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
