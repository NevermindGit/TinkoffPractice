import UIKit

final class MainTabBarController: UITabBarController {

    var viewModel: MainTabBarViewModelProtocol!
    
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
        guard let userRole = UserCredentials.loadFromCoreData()?.userRole else { return }
        viewControllers = viewModel.getViewControllers(for: userRole)
    }
}
