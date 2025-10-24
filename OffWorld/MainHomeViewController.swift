//
//  MainHomeViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit

final class MainHomeViewController: UIViewController {

    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerImageView = UIImageView(image: UIImage(systemName: "globe"))
    private let titleLabel = UILabel()

    private let aboutSection = UIView()
    private let featuresSection = UIView()
    private let projectsSection = UIView()
    private let contactSection = UIView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "OffWorld Home"
        setupLayout()
    }

    // MARK: - Layout Setup
    private func setupLayout() {
        // Add scrollView and contentView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Enable vertical scroll
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true

        // ✅ Use contentLayoutGuide for content size and frameLayoutGuide for visible frame
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // MARK: Header setup
        headerImageView.tintColor = .systemBlue
        headerImageView.contentMode = .scaleAspectFit
        headerImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "🌍 OffWorld"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        [headerImageView, titleLabel].forEach { contentView.addSubview($0) }

        // MARK: Section setup
        let sectionViews = [aboutSection, featuresSection, projectsSection, contactSection]
        sectionViews.forEach { section in
            section.backgroundColor = UIColor.secondarySystemBackground
            section.layer.cornerRadius = 12
            section.layer.borderWidth = 1
            section.layer.borderColor = UIColor.systemGray4.cgColor
            section.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(section)
        }

        // MARK: Section labels
        let aboutLabel = makeSectionLabel(text: "About Section — describe your app’s mission, vision, or purpose here.")
        let featuresLabel = makeSectionLabel(text: "Features Section — list main features or goals.")
        let projectsLabel = makeSectionLabel(text: "Projects Section — showcase your portfolio or achievements.")
        let contactLabel = makeSectionLabel(text: "Contact Section — add links, email, or footer details here.")

        aboutSection.addSubview(aboutLabel)
        featuresSection.addSubview(featuresLabel)
        projectsSection.addSubview(projectsLabel)
        contactSection.addSubview(contactLabel)

        [aboutLabel, featuresLabel, projectsLabel, contactLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: $0.superview!.topAnchor, constant: 20),
                $0.leadingAnchor.constraint(equalTo: $0.superview!.leadingAnchor, constant: 15),
                $0.trailingAnchor.constraint(equalTo: $0.superview!.trailingAnchor, constant: -15),
                $0.bottomAnchor.constraint(equalTo: $0.superview!.bottomAnchor, constant: -20)
            ])
        }

        // MARK: Constraints
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            headerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 80),
            headerImageView.widthAnchor.constraint(equalToConstant: 80),

            titleLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            aboutSection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            aboutSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            aboutSection.heightAnchor.constraint(equalToConstant: 180),

            featuresSection.topAnchor.constraint(equalTo: aboutSection.bottomAnchor, constant: 25),
            featuresSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            featuresSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            featuresSection.heightAnchor.constraint(equalToConstant: 180),

            projectsSection.topAnchor.constraint(equalTo: featuresSection.bottomAnchor, constant: 25),
            projectsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            projectsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            projectsSection.heightAnchor.constraint(equalToConstant: 180),

            contactSection.topAnchor.constraint(equalTo: projectsSection.bottomAnchor, constant: 25),
            contactSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactSection.heightAnchor.constraint(equalToConstant: 180),

            // ✅ Critical for scroll height
            contactSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
    }

    // MARK: - Helper
    private func makeSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }

    // MARK: - Debug (Optional)
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("🧩 Scroll frame:", scrollView.frame, " | contentSize:", scrollView.contentSize)
    }
}
