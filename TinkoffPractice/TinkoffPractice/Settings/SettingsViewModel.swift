import UIKit


protocol SettingsViewModelProtocol: AnyObject {
    var settingsOptions: [SettingsOption] { get }
    func didTapExitButton()
    func handleDarkModeSwitch(isOn: Bool)
    func getTitle(forOptionAt index: Int) -> String
    func getIcon(forOptionAt index: Int, inDarkMode: Bool) -> UIImage?
    func getAccessoryType(forOptionAt index: Int) -> UITableViewCell.AccessoryType
    func shouldDisplayDarkModeSwitch(forOptionAt index: Int) -> Bool
    func didSelectOption(at index: Int) -> UIViewController?
}

final class SettingsViewModel: SettingsViewModelProtocol {
    
    var settingsOptions: [SettingsOption] = [.account, .balance, .darkMode, .aboutApp]
    
    init() {
        if UserCredentials.loadFromCoreData()?.userRole == "Покупатель" {
            settingsOptions.insert(.ordersHistory, at: 1)
        } else {
            settingsOptions.insert(.myProducts, at: 1)
        }
    }

    func didTapExitButton() {
        UserCredentials.deleteFromCoreData()
        
        let navLoginVC = UINavigationController(rootViewController: LoginViewController(dataManager: DataManager.shared))
        navLoginVC.modalPresentationStyle = .fullScreen
        
        // return navLoginVC for presenting in ViewController
    }

    func handleDarkModeSwitch(isOn: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if isOn {
                // User prefers dark mode
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            } else {
                // User prefers light mode
                windowScene.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }

    func getTitle(forOptionAt index: Int) -> String {
        return settingsOptions[index].title
    }

    func getIcon(forOptionAt index: Int, inDarkMode: Bool) -> UIImage? {
        guard settingsOptions.indices.contains(index) else { return nil }
        let option = settingsOptions[index]
        
        let icon = option.icon
        let color: UIColor = inDarkMode ? .white : .black
        return icon?.withTintColor(color, renderingMode: .alwaysOriginal)
    }

    func getAccessoryType(forOptionAt index: Int) -> UITableViewCell.AccessoryType {
        return settingsOptions[index].accessoryType
    }

    func shouldDisplayDarkModeSwitch(forOptionAt index: Int) -> Bool {
        return settingsOptions[index] == .darkMode
    }

    func didSelectOption(at index: Int) -> UIViewController? {
        guard let title = OptionTitle(rawValue: getTitle(forOptionAt: index)) else { return nil }
        switch title {
        case .account:
            return AccountViewController()
        case .ordersHistory:
            return OrdersHistoryViewController()
        case .myProducts:
            return MyProductsViewController()
        case .balance:
            return BalanceViewController()
        case .aboutApp:
            return AboutAppViewController()
        }
    }
}
