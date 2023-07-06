import UIKit

final class MainTabBarController: UITabBarController {

    var viewModel: MainTabBarViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainTabBarViewModel()
        configureViewControllers()
    }

    func configureViewControllers() {
        let userRole = UserCredentials.loadFromCoreData()?.userRole ?? ""
        viewControllers = viewModel.getViewControllers(for: userRole)
    }
}
