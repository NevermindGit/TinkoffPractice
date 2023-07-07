import UIKit

final class MainTabBarController: UITabBarController {

    private var viewModel: MainTabBarViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainTabBarViewModel()
        configureViewControllers()
        updateTabBarAppearance()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateTabBarAppearance()
    }

    func updateTabBarAppearance() {
        tabBar.standardAppearance = viewModel.getTabBarAppearance(for: traitCollection.userInterfaceStyle)
    }

    func configureViewControllers() {
        let userRole = DataManager.shared.getUserRole()
        viewControllers = viewModel.getViewControllers(for: userRole)
    }
}
