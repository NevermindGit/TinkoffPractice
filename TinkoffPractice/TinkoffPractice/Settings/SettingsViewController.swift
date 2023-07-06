import UIKit

final class SettingsViewController: BaseViewController {
    
    // MARK: - Properties
    
    private var viewModel: SettingsViewModelProtocol!
    
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
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
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
        viewModel = SettingsViewModel()
        configureUI()
    }
    
    // MARK: - Private methods
    
    @objc
    private func exitButtonDidTap() {
        viewModel.didTapExitButton()
    }

    @objc
    private func handleDarkModeSwitch(_ sender: UISwitch) {
        viewModel.handleDarkModeSwitch(isOn: sender.isOn)
        // reload table view to update the icon colors
        tableView.reloadData()
    }

    private func configureUI() {
        navigationItem.title = "Настройки"
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(tableView)
        view.addSubview(exitButton)

        setupConstraints()
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
        if let controller = viewModel.didSelectOption(at: indexPath.row) {
            navigationController?.pushViewController(controller, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.getTitle(forOptionAt: indexPath.row)
        
        let darkMode = (traitCollection.userInterfaceStyle == .dark)
        cell.imageView?.image = viewModel.getIcon(forOptionAt: indexPath.row, inDarkMode: darkMode)
        
        cell.accessoryType = viewModel.getAccessoryType(forOptionAt: indexPath.row)
        
        if viewModel.shouldDisplayDarkModeSwitch(forOptionAt: indexPath.row) {
            cell.accessoryView = darkModeSwitch
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}
