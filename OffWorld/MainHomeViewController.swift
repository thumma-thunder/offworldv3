//
//  MainHomeViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit

final class MainHomeViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerImageView = UIImageView(image: UIImage(systemName: "globe"))
    private let titleLabel = UILabel()
    private let aboutSection = UIView()
    private let featuresSection = UIView()
    private let projectsSection = UIView()
    private let contactSection = UIView()
    private let testLoginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "OffWorld Home"
        setupScrollLayout()
        setupContent()
    }

    // MARK: - Scroll + Layout
    private func setupScrollLayout() {
        // ScrollView setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)

        // Content View inside scrollView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    // MARK: - Content
    private func setupContent() {
        headerImageView.tintColor = .systemBlue
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "🌍 OffWorld"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        [aboutSection, featuresSection, projectsSection, contactSection].forEach {
            $0.backgroundColor = UIColor.secondarySystemBackground
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.systemGray4.cgColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        contentView.addSubview(headerImageView)
        contentView.addSubview(titleLabel)

        let aboutLabel = makeLabel("About Section — describe your app’s mission, vision, or purpose here.")
        let featuresLabel = makeLabel("Features Section — list main features or goals.")
        let projectsLabel = makeLabel("Projects Section — showcase your portfolio or achievements.")
        let contactLabel = makeLabel("Contact Section — add links, email, or footer details here.")

        [aboutSection: aboutLabel, featuresSection: featuresLabel,
         projectsSection: projectsLabel, contactSection: contactLabel].forEach { section, label in
            section.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: section.topAnchor, constant: 16),
                label.leadingAnchor.constraint(equalTo: section.leadingAnchor, constant: 16),
                label.trailingAnchor.constraint(equalTo: section.trailingAnchor, constant: -16),
                label.bottomAnchor.constraint(equalTo: section.bottomAnchor, constant: -16)
            ])
        }

        // Test Login Button
        testLoginButton.setTitle("🔐 Test Login", for: .normal)
        testLoginButton.backgroundColor = .systemBlue
        testLoginButton.setTitleColor(.white, for: .normal)
        testLoginButton.layer.cornerRadius = 10
        testLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        testLoginButton.translatesAutoresizingMaskIntoConstraints = false
        testLoginButton.addTarget(self, action: #selector(openLogin), for: .touchUpInside)
        contentView.addSubview(testLoginButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            headerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            aboutSection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            aboutSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            aboutSection.heightAnchor.constraint(equalToConstant: 150),

            featuresSection.topAnchor.constraint(equalTo: aboutSection.bottomAnchor, constant: 25),
            featuresSection.leadingAnchor.constraint(equalTo: aboutSection.leadingAnchor),
            featuresSection.trailingAnchor.constraint(equalTo: aboutSection.trailingAnchor),
            featuresSection.heightAnchor.constraint(equalToConstant: 150),

            projectsSection.topAnchor.constraint(equalTo: featuresSection.bottomAnchor, constant: 25),
            projectsSection.leadingAnchor.constraint(equalTo: aboutSection.leadingAnchor),
            projectsSection.trailingAnchor.constraint(equalTo: aboutSection.trailingAnchor),
            projectsSection.heightAnchor.constraint(equalToConstant: 150),

            contactSection.topAnchor.constraint(equalTo: projectsSection.bottomAnchor, constant: 25),
            contactSection.leadingAnchor.constraint(equalTo: aboutSection.leadingAnchor),
            contactSection.trailingAnchor.constraint(equalTo: aboutSection.trailingAnchor),
            contactSection.heightAnchor.constraint(equalToConstant: 150),

            testLoginButton.topAnchor.constraint(equalTo: contactSection.bottomAnchor, constant: 40),
            testLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            testLoginButton.widthAnchor.constraint(equalToConstant: 200),
            testLoginButton.heightAnchor.constraint(equalToConstant: 50),
            testLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // MARK: - Navigation
    @objc private func openLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
}
