//
//  SignupViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit

final class SignupViewController: UIViewController {

    private let dbHelper = DatabaseHelper.shared

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let usernameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let showPasswordButton = UIButton(type: .custom)
    private let accountTypeControl = UISegmentedControl(items: ["Business", "Individual"])
    private let zipcodeField = UITextField()
    private let signupButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Account"
        setupLayout()
        registerForKeyboardNotifications()
    }

    // MARK: - Layout Setup
    private func setupLayout() {
        // ScrollView setup
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .interactive
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

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

        // Fields
        [usernameField, emailField, passwordField, zipcodeField].forEach {
            $0.borderStyle = .roundedRect
            $0.autocapitalizationType = .none
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        usernameField.placeholder = "Username"
        emailField.placeholder = "Email"
        passwordField.placeholder = "Password"
        passwordField.isSecureTextEntry = true
        zipcodeField.placeholder = "Zip Code"
        zipcodeField.keyboardType = .numberPad

        // 👁️ Show Password Button
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        passwordField.rightView = showPasswordButton
        passwordField.rightViewMode = .always

        // Account type
        accountTypeControl.selectedSegmentIndex = 0
        accountTypeControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accountTypeControl)

        // Signup button
        signupButton.setTitle("Create Account", for: .normal)
        signupButton.backgroundColor = .systemBlue
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 12
        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        contentView.addSubview(signupButton)

        // Layout
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            usernameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            usernameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),

            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),

            accountTypeControl.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            accountTypeControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            zipcodeField.topAnchor.constraint(equalTo: accountTypeControl.bottomAnchor, constant: 25),
            zipcodeField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            zipcodeField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),

            signupButton.topAnchor.constraint(equalTo: zipcodeField.bottomAnchor, constant: 40),
            signupButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signupButton.widthAnchor.constraint(equalToConstant: 200),
            signupButton.heightAnchor.constraint(equalToConstant: 50),
            signupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
    }

    // MARK: - Keyboard Handling
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = keyboardFrame.cgRectValue.height
            scrollView.contentInset.bottom = height + 20
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }

    // MARK: - Password Toggle
    @objc private func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let iconName = passwordField.isSecureTextEntry ? "eye" : "eye.slash"
        showPasswordButton.setImage(UIImage(systemName: iconName), for: .normal)
    }

    // MARK: - Handle Signup
    @objc private func handleSignup() {
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              let zipcode = zipcodeField.text,
              !username.isEmpty, !email.isEmpty, !password.isEmpty, !zipcode.isEmpty else {
            showAlert(title: "Missing Info", message: "Please fill out all fields.")
            return
        }

        let accountType = accountTypeControl.titleForSegment(at: accountTypeControl.selectedSegmentIndex) ?? "Individual"

        if dbHelper.createUser(username: username,
                               email: email,
                               password: password,
                               accountType: accountType,
                               zipcode: zipcode) {
            print("✅ User saved successfully.")
            UserDefaults.standard.setValue(accountType, forKey: "accountType")
            showAlert(title: "Success", message: "Account created successfully!") {
                self.navigationController?.pushViewController(MainHomeViewController(), animated: true)
            }
        } else {
            showAlert(title: "Error", message: "We couldn't save your account right now. Please try again.")
        }
    }

    // MARK: - Helper
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}
