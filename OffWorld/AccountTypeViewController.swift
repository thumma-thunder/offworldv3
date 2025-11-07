//
//  AccountTypeViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/17/25.
//

import UIKit

final class AccountTypeViewController: UIViewController {

    private let titleLabel = UILabel()
    private let businessButton = UIButton(type: .system)
    private let individualButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Who are you?"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemBlue
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        [businessButton, individualButton].forEach {
            $0.backgroundColor = .systemBlue
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        businessButton.setTitle("I am a Business", for: .normal)
        individualButton.setTitle("I am an Individual", for: .normal)

        businessButton.addTarget(self, action: #selector(selectBusiness), for: .touchUpInside)
        individualButton.addTarget(self, action: #selector(selectIndividual), for: .touchUpInside)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            businessButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            businessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            businessButton.widthAnchor.constraint(equalToConstant: 240),
            businessButton.heightAnchor.constraint(equalToConstant: 55),

            individualButton.topAnchor.constraint(equalTo: businessButton.bottomAnchor, constant: 20),
            individualButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            individualButton.widthAnchor.constraint(equalToConstant: 240),
            individualButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    @objc private func selectBusiness() {
        goToMainPage(accountType: "Business")
    }

    @objc private func selectIndividual() {
        goToMainPage(accountType: "Individual")
    }

    private func goToMainPage(accountType: String) {
        UserDefaults.standard.set(accountType, forKey: "accountType")
        let mainVC = MainHomeViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
