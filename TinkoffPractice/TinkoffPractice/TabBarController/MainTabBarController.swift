import UIKit

final class MainTabBarController: UITabBarController {

    var viewModel: MainTabBarViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainTabBarViewModel()
        configureViewControllers()
        tabBar.tintColor = .black
    }

    func configureViewControllers() {
        guard let userRole = UserCredentials.loadFromCoreData()?.userRole else { return }
        viewControllers = viewModel.getViewControllers(for: userRole)
    }
}
