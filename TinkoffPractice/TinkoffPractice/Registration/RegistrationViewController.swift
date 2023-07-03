import UIKit
import SnapKit


class RegistrationViewController: BaseViewController {
    
    var viewModel: RegistrationViewModelProtocol!
    private let dataManager = DataManager.shared
    
    //MARK: - Properties
    private let loginTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Номер телефона или почта"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    private let userInfoTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Имя Фамилия"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    private var passwordTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Пароль"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmPasswordTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Подтвердите пароль"
        textField.layer.cornerRadius = 10
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var registerButton: BaseButton = {
        let button = BaseButton(type: .roundedRect)
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(registerButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func registerButtonDidTap() {
        viewModel.registerButtonButtonTapped?()
    }
    
    @objc func segmentedControlValueChanged(segmentedControl: UISegmentedControl) {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        if selectedSegmentIndex == 0 {
            viewModel.userRole = .buyer
        } else {
            viewModel.userRole = .seller
        }
    }
    
    private func bindViewModel() {
        viewModel = RegistrationViewModel(dataManager: dataManager)
        viewModel.registerButtonButtonTapped = { [weak self] in
            self?.handleRegistrationButtonTapped()
        }
    }
    
    private func handleRegistrationButtonTapped() {
        guard let login = loginTextField.text else { return }
        guard let userInfo = userInfoTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        let mainTabBar = MainTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        mainTabBar.modalTransitionStyle = .coverVertical
        mainTabBar.modalPresentationCapturesStatusBarAppearance = true
        viewModel.addUserToDatabase(login: login, userInfo: userInfo, password: pass)
        DispatchQueue.main.async { [weak self] in
            self?.present(mainTabBar, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Регистрация"
        navigationItem.largeTitleDisplayMode = .never
        bindViewModel()
        setupUI()
    }

    
    private func setupUI() {
        view.addSubview(loginTextField)
        view.addSubview(userInfoTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        let segmentedControl = UISegmentedControl(items: ["Покупатель", "Продавец"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        view.addSubview(segmentedControl)
        
        loginTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height * 0.075)
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.04)
        }
        
        userInfoTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginTextField.snp.bottom).offset(view.frame.height * 0.025)
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.04)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userInfoTextField.snp.bottom).offset(view.frame.height * 0.025)
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.04)
        }

        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(view.frame.height * 0.025)
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.04)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(view.frame.height * 0.025)
            make.width.equalTo(view.frame.width * 0.95)
            make.height.equalTo(view.frame.height * 0.04)
        }

        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(view.frame.height * 0.04)
            make.width.equalTo(view.frame.width * 0.95)
            make.height.equalTo(view.frame.height * 0.06)
        }
        
    }
    
}
