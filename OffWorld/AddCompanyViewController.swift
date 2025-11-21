//
//  AddCompanyViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 11/6/25.
//

import UIKit

final class AddCompanyViewController: UIViewController {

    private let dbHelper = DatabaseHelper.shared

    private let nameField = UITextField()
    private let descriptionField = UITextField()
    private let websiteField = UITextField()
    private let categoryField = UITextField()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Your Company"
        view.backgroundColor = .systemBackground
        setupUI()
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
        guard let name = nameField.text, !name.isEmpty else {
            showAlert(title: "Missing Name", message: "Please add a company name before submitting.")
            return
        }

        let inserted = dbHelper.insertCompany(name: name,
                                              description: descriptionField.text ?? "",
                                              website: websiteField.text ?? "",
                                              category: categoryField.text ?? "")

        if inserted {
            print("✅ Company added!")
            navigationController?.popViewController(animated: true)
        } else {
            showAlert(title: "Error", message: "We couldn't add this company right now. Please try again.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
