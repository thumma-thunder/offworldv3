//
//  CompaniesMainViewController.swift
//  OffWorld
//

import UIKit

final class CompaniesMainViewController: UIViewController {

    private let dbHelper = DatabaseHelper.shared
    private let scrollView = UIScrollView()
    private let listStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Companies"
        view.backgroundColor = .systemBackground

        setupScrollView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadCompanyList()
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

    private func reloadCompanyList() {
        listStack.arrangedSubviews.forEach { view in
            listStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        setupHeaderDependingOnUser()

        let companies = dbHelper.fetchCompanies()

        if companies.isEmpty {
            let emptyView = placeholderCard(text: "🚀 No companies yet. Add yours to get started!")
            listStack.addArrangedSubview(emptyView)
        } else {
            companies.forEach { company in
                listStack.addArrangedSubview(companyCard(for: company))
            }
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
        label.numberOfLines = 0

        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
    }

    private func companyCard(for company: Company) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.secondarySystemBackground
        card.layer.cornerRadius = 14
        card.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let nameLabel = UILabel()
        nameLabel.text = company.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textColor = .systemBlue

        let descriptionLabel = UILabel()
        descriptionLabel.text = company.description.isEmpty ? "No description provided." : company.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .secondaryLabel

        let categoryLabel = UILabel()
        categoryLabel.text = company.category.isEmpty ? "Category: Unspecified" : "Category: \(company.category)"
        categoryLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        categoryLabel.textColor = .systemGray

        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, categoryLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        if !company.website.isEmpty {
            let websiteLabel = UILabel()
            websiteLabel.text = company.website
            websiteLabel.font = UIFont.systemFont(ofSize: 14)
            websiteLabel.textColor = .link
            websiteLabel.numberOfLines = 0
            stack.addArrangedSubview(websiteLabel)
        }

        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.layoutMarginsGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: card.layoutMarginsGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: card.layoutMarginsGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: card.layoutMarginsGuide.bottomAnchor)
        ])

        return card
    }

    @objc private func openAddCompany() {
        let addVC = AddCompanyViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }
}
