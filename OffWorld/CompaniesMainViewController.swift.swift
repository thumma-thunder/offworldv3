//
//  CompaniesMainViewController.swift
//  OffWorld
//

import UIKit

final class CompaniesMainViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let listStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Companies"
        view.backgroundColor = .systemBackground

        setupScrollView()
        setupHeaderDependingOnUser()
        setupPlaceholderList()   // You will later replace this with real DB loading
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        listStack.axis = .vertical
        listStack.spacing = 16
        listStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(listStack)

        NSLayoutConstraint.activate([
            listStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            listStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            listStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            listStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            listStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func setupHeaderDependingOnUser() {
        let accountType = UserDefaults.standard.string(forKey: "accountType") ?? "Individual"

        // Only Business users get the "Add Company" button
        if accountType == "Business" {
            let addButton = UIButton(type: .system)
            addButton.setTitle("Add / Sign in as Company", for: .normal)
            addButton.backgroundColor = .systemBlue
            addButton.setTitleColor(.white, for: .normal)
            addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            addButton.layer.cornerRadius = 12
            addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true

            addButton.addTarget(self, action: #selector(openAddCompany), for: .touchUpInside)
            listStack.addArrangedSubview(addButton)
        }
    }

    // --- Template placeholder rectangles ---
    private func setupPlaceholderList() {
        for i in 1...5 {
            let card = placeholderCard(text: "Company \(i)")
            listStack.addArrangedSubview(card)
        }
    }

    private func placeholderCard(text: String) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 14
        card.heightAnchor.constraint(equalToConstant: 100).isActive = true

        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
    }

    @objc private func openAddCompany() {
        let addVC = AddCompanyViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }
}
