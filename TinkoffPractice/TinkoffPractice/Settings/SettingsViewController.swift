import UIKit

final class SettingsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var settingsOptions: [SettingsOption] = [.account, .balance, .darkMode, .aboutApp]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var exitButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Выйти", for: .normal)
//        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(exitButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var darkModeSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.onTintColor = .systemBlue
        switchControl.addTarget(self, action: #selector(handleDarkModeSwitch), for: .valueChanged)
        return switchControl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Private methods
    
    @objc
    private func exitButtonDidTap() {
        UserCredentials.deleteFromCoreData()
        
        let navLoginVC = UINavigationController(rootViewController: LoginViewController(dataManager: DataManager.shared))
        navLoginVC.modalPresentationStyle = .fullScreen
        present(navLoginVC, animated: true)
    }

    @objc
    private func handleDarkModeSwitch(_ sender: UISwitch) {
        print("Dark Mode: \(sender.isOn)")
    }
    
    private func configureUI() {
        navigationItem.title = "Настройки"
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(tableView)
        view.addSubview(exitButton)

        configureCellViaRole()
        setupConstraints()

    }
    
    private func configureCellViaRole() {
        if UserCredentials.loadFromCoreData()?.userRole == "Покупатель" {
            settingsOptions.insert(.ordersHistory, at: 1)
        } else {
            settingsOptions.insert(.myProducts, at: 1)
        }
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }

        exitButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(56)
        }
    }

}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = settingsOptions[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected \(option.title)")
        
        guard let title = OptionTitle(rawValue: option.title) else { return }
        switch title {
        case .account:
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
        case .ordersHistory:
            let ordersHistoryVC = OrdersHistoryViewController()
            navigationController?.pushViewController(ordersHistoryVC, animated: true)
        case .myProducts:
            let myProductsVC = MyProductsViewController()
            navigationController?.pushViewController(myProductsVC, animated: true)
        case .balance:
            let balanceVC = BalanceViewController()
            navigationController?.pushViewController(balanceVC, animated: true)
        case .aboutApp:
            let aboutAppVC = AboutAppViewController()
            navigationController?.pushViewController(aboutAppVC, animated: true)
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let option = settingsOptions[indexPath.row] 
        cell.textLabel?.text = option.title
        cell.imageView?.image = option.icon?.withTintColor(.black, renderingMode: .alwaysOriginal)
        cell.accessoryType = option.accessoryType
        
        if option == .darkMode {
            cell.accessoryView = darkModeSwitch
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}
