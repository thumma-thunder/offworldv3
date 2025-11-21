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

        // 🌍 Title Label
        titleLabel.text = "Are you a Company or a User?"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold) // ⬅️ smaller font
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // 🔹 Configure buttons (shared style)
        [businessButton, individualButton].forEach {
            $0.backgroundColor = .systemBlue
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 14
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium) // ⬅️ slightly smaller
            $0.heightAnchor.constraint(equalToConstant: 55).isActive = true
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .white
            view.addSubview($0)
        }

        // 🏢 Business Button
        businessButton.setTitle("  Business", for: .normal)
        businessButton.setImage(UIImage(systemName: "building.2.crop.circle.fill"), for: .normal)
        businessButton.imageView?.contentMode = .scaleAspectFit
        businessButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        businessButton.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)

        // 👤 Individual Button
        individualButton.setTitle("  Individual", for: .normal)
        individualButton.setImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal)
        individualButton.imageView?.contentMode = .scaleAspectFit
        individualButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        individualButton.addTarget(self, action: #selector(handleSelection(_:)), for: .touchUpInside)

        // Layout
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50), // ⬅️ less spacing
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            businessButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40), // ⬅️ less spacing
            businessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessButton.widthAnchor.constraint(equalToConstant: 250),

            individualButton.topAnchor.constraint(equalTo: businessButton.bottomAnchor, constant: 20), // ⬅️ less spacing
            individualButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            individualButton.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

        // Navigate to main page
    @objc private func handleSelection(_ sender: UIButton) {
        // Trim spaces from button title
        let selectedType = sender.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Individual"

        // Save normalized value
        UserDefaults.standard.set(selectedType, forKey: "accountType")

        // Navigate to companies screen
        let companiesVC = CompaniesMainViewController()
        navigationController?.pushViewController(companiesVC, animated: true)
    }


        }

    

