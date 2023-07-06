import UIKit

final class SettingsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var exitButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .systemRed
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.layer.cornerRadius = 10

        view.addSubview(tableView)
        view.addSubview(exitButton)

        setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.07)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = SettingsOption(rawValue: indexPath.row) else { return }
        print("Selected \(option.title)")
        // ... further actions based on selected option
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsOption.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let option = SettingsOption(rawValue: indexPath.row) else { return UITableViewCell() }
        cell.textLabel?.text = option.title
        cell.imageView?.image = option.icon?.withTintColor(.black, renderingMode: .alwaysOriginal)
        cell.accessoryType = option.accessoryType
        
        // Add the switch control to the dark mode cell
        if option == .darkMode {
            cell.accessoryView = darkModeSwitch
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}
