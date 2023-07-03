import UIKit
import SnapKit


class LoginViewController: BaseViewController {
    
    private var viewModel: LoginViewModelProtocol!
    private let dataManager = DataManager.shared

    
    //MARK: - Properties
    
    private let loginTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Введите логин"
        textField.autocapitalizationType = .none
        return textField
    }()
    
    private let passwordTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет аккаунта?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
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
        let button = BaseButton(type: .roundedRect)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        CoreDataService.shared.fetchAllUsers()
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
                    self.present(mainTabBar, animated: true)
                }
            } else {
                print("Error")
            }
        }
    }

    private func handleGoToRegistrationButtonTap() {
        let regVC = RegistrationViewController()
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(regVC, animated: true)
        }
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height * 0.15)
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.04)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginTextField.snp.bottom).offset(view.frame.height * 0.025)
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.04)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(view.frame.height * 0.01)
        }
        
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(view.frame.height * 0.04)
            make.width.equalTo(view.frame.width * 0.95)
            make.height.equalTo(view.frame.height * 0.06)
        }

    }
}

