//
//  AddCompanyViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 11/6/25.
//

import UIKit
import SQLite3

final class AddCompanyViewController: UIViewController {

    private var db: OpaquePointer?

    private let nameField = UITextField()
    private let descriptionField = UITextField()
    private let websiteField = UITextField()
    private let categoryField = UITextField()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Your Company"
        view.backgroundColor = .systemBackground
        setupDatabase()
        setupUI()
    }

    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("OffWorldUsers.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        }
    }

    private func setupUI() {
        [nameField, descriptionField, websiteField, categoryField].forEach {
            $0.borderStyle = .roundedRect
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        nameField.placeholder = "Company Name"
        descriptionField.placeholder = "Description"
        websiteField.placeholder = "Website"
        categoryField.placeholder = "Category"

        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 12
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(addCompany), for: .touchUpInside)
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([
            nameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            descriptionField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            descriptionField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            descriptionField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),

            websiteField.topAnchor.constraint(equalTo: descriptionField.bottomAnchor, constant: 20),
            websiteField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            websiteField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),

            categoryField.topAnchor.constraint(equalTo: websiteField.bottomAnchor, constant: 20),
            categoryField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            categoryField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),

            submitButton.topAnchor.constraint(equalTo: categoryField.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func addCompany() {
        guard let name = nameField.text, !name.isEmpty else { return }

        let insertQuery = "INSERT INTO Companies (name, description, website, category) VALUES (?, ?, ?, ?)"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, name, -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, descriptionField.text ?? "", -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, websiteField.text ?? "", -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 4, categoryField.text ?? "", -1, SQLITE_TRANSIENT)

            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ Company added!")
                navigationController?.popViewController(animated: true)
            } else {
                print("❌ Failed to add company")
            }
        }

        sqlite3_finalize(stmt)
    }
}
