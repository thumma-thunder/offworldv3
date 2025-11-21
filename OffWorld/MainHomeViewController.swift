//
//  MainHomeViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/24/25.
//

import UIKit
import SQLite3

final class MainHomeViewController: UIViewController {

    private var db: OpaquePointer?
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "OffWorld Home"
        view.backgroundColor = .systemBackground
        setupDatabase()
        setupScrollView()
        setupHeader()
        loadCompanies()
    }

    // MARK: - Database Setup
    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("OffWorldUsers.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ Error opening database")
        }
    }

    // MARK: - Scroll + Content Setup
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - Header UI
    private func setupHeader() {
        let accountType = UserDefaults.standard.string(forKey: "accountType") ?? "Individual"

        let logoImageView = UIImageView(image: UIImage(systemName: "globe"))
        logoImageView.tintColor = .systemBlue
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "🌍 OffWorld"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemBlue

        // Button Stack
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        // 👔 Show Add Company button only for Business users
        if accountType == "Business" {
            let addCompanyButton = UIButton(type: .system)
            addCompanyButton.setTitle("Add Company", for: .normal)
            addCompanyButton.backgroundColor = .systemBlue
            addCompanyButton.setTitleColor(.white, for: .normal)
            addCompanyButton.layer.cornerRadius = 10
            addCompanyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            addCompanyButton.addTarget(self, action: #selector(openAddCompany), for: .touchUpInside)
            buttonStack.addArrangedSubview(addCompanyButton)
        }

        // 🧍 Test Login (visible to everyone)
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Test Login", for: .normal)
        loginButton.backgroundColor = .systemGray
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 10
        loginButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        loginButton.addTarget(self, action: #selector(openLogin), for: .touchUpInside)

        buttonStack.addArrangedSubview(loginButton)

        // Header Stack
        let headerStack = UIStackView(arrangedSubviews: [logoImageView, titleLabel, buttonStack])
        headerStack.axis = .vertical
        headerStack.spacing = 16
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addArrangedSubview(headerStack)

        // Small welcome text
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome, \(accountType) User!"
        welcomeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        welcomeLabel.textColor = .secondaryLabel
        welcomeLabel.textAlignment = .center
        contentView.addArrangedSubview(welcomeLabel)
    }

    // MARK: - Load Companies
    private func loadCompanies() {
        let query = "SELECT name, description, category FROM Companies ORDER BY created_at DESC;"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            var hasCompanies = false
            while sqlite3_step(stmt) == SQLITE_ROW {
                hasCompanies = true
                let name = String(cString: sqlite3_column_text(stmt, 0))
                let desc = String(cString: sqlite3_column_text(stmt, 1))
                let category = String(cString: sqlite3_column_text(stmt, 2))
                addCompanySection(name: name, description: desc, category: category)
            }
            if !hasCompanies { addPlaceholderSection() }
        } else {
            print("❌ Failed to fetch companies.")
        }
        sqlite3_finalize(stmt)
    }

    // MARK: - Company Cards
    private func addCompanySection(name: String, description: String, category: String) {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 14
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.1
        card.layer.shadowOffset = CGSize(width: 0, height: 3)
        card.layer.shadowRadius = 5
        card.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .systemBlue
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let descLabel = UILabel()
        descLabel.text = description.isEmpty ? "No description provided." : description
        descLabel.numberOfLines = 0
        descLabel.textColor = .secondaryLabel
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        let categoryLabel = UILabel()
        categoryLabel.text = "Category: \(category)"
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        categoryLabel.textColor = .systemGray
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(nameLabel)
        card.addSubview(descLabel)
        card.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -15),

            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            categoryLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -15)
        ])

        contentView.addArrangedSubview(card)
    }

    private func addPlaceholderSection() {
        let placeholder = UILabel()
        placeholder.text = "🚀 No companies yet — be the first to add yours!"
        placeholder.textAlignment = .center
        placeholder.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        placeholder.textColor = .secondaryLabel
        placeholder.numberOfLines = 0
        contentView.addArrangedSubview(placeholder)
    }

    // MARK: - Navigation
    @objc private func openAddCompany() {
        let addVC = AddCompanyViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }

    @objc private func openLogin() {
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
