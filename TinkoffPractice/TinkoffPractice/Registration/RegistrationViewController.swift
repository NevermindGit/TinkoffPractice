import UIKit
import SnapKit


final class RegistrationViewController: BaseViewController {
    
    private var viewModel: RegistrationViewModelProtocol!
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties
    private lazy var loginTextField = createTextField(placeholder: "Номер телефона или почта")
    private lazy var userInfoTextField = createTextField(placeholder: "Имя Фамилия")
    private lazy var passwordTextField = createTextField(placeholder: "Пароль", isSecure: true)
    private lazy var confirmPasswordTextField = createTextField(placeholder: "Подтвердите пароль", isSecure: true)
    
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
    
    private func createTextField(placeholder: String, isSecure: Bool = false) -> BaseTextField {
        let textField = BaseTextField()
        textField.placeholder = placeholder
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = isSecure
        return textField
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(40)
        }
        
        userInfoTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginTextField.snp.bottom).offset(20)
            make.width.equalTo(loginTextField)
            make.height.equalTo(loginTextField)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(userInfoTextField.snp.bottom).offset(20)
            make.width.equalTo(loginTextField)
            make.height.equalTo(loginTextField)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(loginTextField)
            make.height.equalTo(loginTextField)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(20)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(loginTextField)
        }
        
        registerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(50)
        }
    }
    
}
