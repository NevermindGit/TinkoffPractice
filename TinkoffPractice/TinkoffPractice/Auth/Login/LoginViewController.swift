import UIKit
import SnapKit

final class LoginViewController: BaseViewController {

    private var viewModel: LoginViewModelProtocol!
    private let dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Properties

    private lazy var loginTextField: BaseTextField = createTextField(placeholder: "Введите логин")
    private lazy var passwordTextField: BaseTextField = createTextField(placeholder: "Введите пароль", isSecure: true)

    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет аккаунта?"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private lazy var goToRegistrartionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Регистрация", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.addTarget(self, action: #selector(goToRegistrartionButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var continueButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        return button
    }()

    @objc
    private func goToRegistrartionButtonDidTap() {
        viewModel.goToRegistrationButtonTapped?()
    }

    @objc
    private func continueButtonDidTap() {
        viewModel.loginButtonTapped?()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Здравствуйте"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        setupUI()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel = LoginViewModel(dataManager: dataManager)
        viewModel.loginButtonTapped = { [weak self] in
            self?.handleLoginButtonTap()
        }
        viewModel.goToRegistrationButtonTapped = { [weak self] in
            self?.handleGoToRegistrationButtonTap()
        }
    }

    private func handleLoginButtonTap() {
        guard let login = loginTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        let mainTabBar = MainTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        mainTabBar.modalTransitionStyle = .coverVertical
        mainTabBar.modalPresentationCapturesStatusBarAppearance = true
        viewModel.performLogin(login: login, password: pass) { [weak self] exist in
            guard let self = self else { return }
            if exist {
                DispatchQueue.main.async {
                    mainTabBar.configureViewControllers()
                    self.present(mainTabBar, animated: true)
                }
            } else {
                print("Error")
            }
        }
    }


    private func handleGoToRegistrationButtonTap() {
        let regVC = RegistrationViewController(dataManager: DataManager.shared)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(regVC, animated: true)
        }
    }

    private func createTextField(placeholder: String, isSecure: Bool = false) -> BaseTextField {
        let textField = BaseTextField()
        textField.placeholder = placeholder
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecure
        return textField
    }

    private func setupUI() {
        view.addSubview(loginTextField)
        view.addSubview(passwordTextField)
        view.addSubview(noAccountLabel)
        view.addSubview(goToRegistrartionButton)
        view.addSubview(continueButton)

        let stackView = UIStackView(arrangedSubviews: [noAccountLabel, goToRegistrartionButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center

        view.addSubview(stackView)

        loginTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.width.equalTo(loginTextField)
            make.height.equalTo(loginTextField)
        }

        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }

        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(56)
        }

    }
}
