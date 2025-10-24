import UIKit

class HomeScreenViewController: UIViewController {

    // MARK: - UI Components

    private let userButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 0
        return button
    }()

    private let companyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.systemGreen
        button.layer.cornerRadius = 0
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtons()
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.backgroundColor = .white

        // Add buttons to view
        view.addSubview(userButton)
        view.addSubview(companyButton)

        // Setup constraints to split screen in half
        NSLayoutConstraint.activate([
            // User button - top half
            userButton.topAnchor.constraint(equalTo: view.topAnchor),
            userButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),

            // Company button - bottom half
            companyButton.topAnchor.constraint(equalTo: userButton.bottomAnchor),
            companyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            companyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            companyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupButtons() {
        // Configure User Button
        configureButton(
            userButton,
            title: "User",
            iconName: "car_icon",
            action: #selector(userButtonTapped)
        )

        // Configure Company Button
        configureButton(
            companyButton,
            title: "Company",
            iconName: "suit_icon",
            action: #selector(companyButtonTapped)
        )
    }

    private func configureButton(_ button: UIButton, title: String, iconName: String, action: Selector) {
        // Create a container stack view for vertical layout
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false // Allow touches to pass through to button

        // Create image view for icon
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        // Try to load custom image, fallback to system image if not available
        if let customImage = UIImage(named: iconName) {
            imageView.image = customImage
        } else {
            // Fallback system images
            let systemImageName = iconName == "car_icon" ? "car.fill" : "briefcase.fill"
            imageView.image = UIImage(systemName: systemImageName)
        }
        imageView.tintColor = .white

        // Create label for title
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        // Add views to stack
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        // Add stack to button
        button.addSubview(stackView)

        // Setup constraints
        NSLayoutConstraint.activate([
            // Center stack view in button
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),

            // Icon size
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Add action
        button.addTarget(self, action: action, for: .touchUpInside)

        // Add touch feedback
        button.addTarget(self, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    // MARK: - Button Actions

    @objc private func userButtonTapped() {
        // Navigate to user authentication flow
        let authVC = AuthViewController()
        authVC.userType = "User" // You can add this property to AuthViewController
        navigationController?.pushViewController(authVC, animated: true)
    }

    @objc private func companyButtonTapped() {
        // Navigate to company authentication flow
        let authVC = AuthViewController()
        authVC.userType = "Company" // You can add this property to AuthViewController
        navigationController?.pushViewController(authVC, animated: true)
    }

    @objc private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.7
        }
    }

    @objc private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 1.0
        }
    }
}
