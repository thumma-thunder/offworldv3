//
//  AuthViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit



final class AuthViewController: UIViewController {

    var userType: String?

    private let titleLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let signupButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        titleLabel.text = "Welcome to OffWorld 🌍"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center

        loginButton.setTitle("Log In", for: .normal)
        signupButton.setTitle("Create Account", for: .normal)

        [loginButton, signupButton].forEach {
            $0.backgroundColor = .systemBlue
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),

            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            loginButton.widthAnchor.constraint(equalToConstant: 220),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupButton.widthAnchor.constraint(equalToConstant: 220),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        loginButton.addTarget(self, action: #selector(showLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(showSignup), for: .touchUpInside)
    }

    @objc private func showLogin() {
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }

    @objc private func showSignup() {
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
}
