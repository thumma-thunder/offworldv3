//
//  LoginViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit

final class LoginViewController: UIViewController {

    private let dbHelper = DatabaseHelper.shared
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let showPasswordButton = UIButton(type: .custom)
    private let loginButton = UIButton(type: .system)
    private let signupPrompt = UILabel()
    private let signupLink = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Log In"
        setupUI()
    }

    private func setupUI() {
        [emailField, passwordField].forEach {
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .none
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true

        // 👁️ Show Password Button
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        passwordField.rightView = showPasswordButton
        passwordField.rightViewMode = .always

        // Login button
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        view.addSubview(loginButton)

        // Signup prompt
        signupPrompt.text = "Don’t have an account?"
        signupPrompt.textColor = .secondaryLabel
        signupPrompt.textAlignment = .center
        signupPrompt.translatesAutoresizingMaskIntoConstraints = false

        signupLink.setTitle("Create one", for: .normal)
        signupLink.setTitleColor(.systemBlue, for: .normal)
        signupLink.addTarget(self, action: #selector(goToSignup), for: .touchUpInside)
        signupLink.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(signupPrompt)
        view.addSubview(signupLink)

        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 40),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

            signupPrompt.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupPrompt.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            signupLink.topAnchor.constraint(equalTo: signupPrompt.bottomAnchor, constant: 6),
            signupLink.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let icon = passwordField.isSecureTextEntry ? "eye" : "eye.slash"
        showPasswordButton.setImage(UIImage(systemName: icon), for: .normal)
    }

    @objc private func handleLogin() {
        guard let email = emailField.text,
              let password = passwordField.text else { return }

        if let accountType = dbHelper.userAccountType(email: email, password: password) {
            UserDefaults.standard.setValue(accountType, forKey: "accountType")
            navigationController?.pushViewController(MainHomeViewController(), animated: true)
        } else {
            showAlert(title: "Login Failed", message: "Incorrect email or password.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func goToSignup() {
        navigationController?.pushViewController(SignupViewController(), animated: true)
    }
}
