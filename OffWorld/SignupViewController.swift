//
//  SignupViewController.swift
//  OffWorld
//
//  Created by Joel Gaikwad on 10/16/25.
//

import UIKit
import SQLite3

final class SignupViewController: UIViewController {

    private var db: OpaquePointer?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
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
        setupDatabase()
        setupUI()
        setupKeyboardObservers()
    }

    // MARK: - SQLite Setup
    private func setupDatabase() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("OffWorldUsers.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("❌ Error opening database")
        }

        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            password TEXT,
            accountType TEXT,
            zipcode TEXT
        );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("❌ Error creating table: \(errmsg)")
        } else {
            print("✅ Users table ready.")
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Scroll setup
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // Title
        titleLabel.text = "Join OffWorld 🌍"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .systemBlue
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

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

        // 👁️ Show/Hide Password Button
        showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPasswordButton.tintColor = .systemGray
        showPasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        passwordField.rightView = showPasswordButton
        passwordField.rightViewMode = .always

        // Account Type
        accountTypeControl.selectedSegmentIndex = 0
        accountTypeControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(accountTypeControl)

        // Button
        signupButton.setTitle("Create Account", for: .normal)
        signupButton.backgroundColor = .systemBlue
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 12
        signupButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        contentView.addSubview(signupButton)

        // Layout (responsive & scrollable)
        let centerYConstraint = contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        centerYConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            centerYConstraint,

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            usernameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            usernameField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            usernameField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            usernameField.heightAnchor.constraint(equalToConstant: 50),

            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            emailField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 50),

            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            passwordField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 50),

            accountTypeControl.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            accountTypeControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            zipcodeField.topAnchor.constraint(equalTo: accountTypeControl.bottomAnchor, constant: 25),
            zipcodeField.leadingAnchor.constraint(equalTo: usernameField.leadingAnchor),
            zipcodeField.trailingAnchor.constraint(equalTo: usernameField.trailingAnchor),
            zipcodeField.heightAnchor.constraint(equalToConstant: 50),

            signupButton.topAnchor.constraint(equalTo: zipcodeField.bottomAnchor, constant: 50),
            signupButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signupButton.widthAnchor.constraint(equalToConstant: 220),
            signupButton.heightAnchor.constraint(equalToConstant: 55),

            signupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60)
        ])
    }

    // MARK: - Keyboard Handling
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let info = notification.userInfo,
              let kbFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let bottomInset = kbFrame.height - view.safeAreaInsets.bottom
        scrollView.contentInset.bottom = bottomInset
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
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
        let insertQuery = "INSERT INTO Users (username, email, password, accountType, zipcode) VALUES (?, ?, ?, ?, ?);"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, (username as NSString).utf8String,   -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 2, (email as NSString).utf8String,      -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 3, (password as NSString).utf8String,   -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 4, (accountType as NSString).utf8String,-1, SQLITE_TRANSIENT)
            sqlite3_bind_text(stmt, 5, (zipcode as NSString).utf8String,    -1, SQLITE_TRANSIENT)

            if sqlite3_step(stmt) == SQLITE_DONE {
                print("✅ User saved successfully in database.")
                showAlert(title: "Success", message: "Account created successfully!") {
                    self.navigationController?.pushViewController(MainHomeViewController(), animated: true)
                }
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                showAlert(title: "Error", message: "Insert failed: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            showAlert(title: "Error", message: "Failed to prepare statement: \(errmsg)")
        }

        sqlite3_finalize(stmt)
    }

    // MARK: - Alerts
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}
