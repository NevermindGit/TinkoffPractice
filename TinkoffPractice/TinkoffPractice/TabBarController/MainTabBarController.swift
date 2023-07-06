import UIKit

final class MainTabBarController: UITabBarController {
    
    private let userRole = UserCredentials.loadFromCoreData()?.userRole ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    private func configureViewControllers() {
        let mainNavVC = UINavigationController(rootViewController: MainViewController())
        mainNavVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)

        let middleNavVC: UINavigationController
        if userRole == "продавец" {
            let vc = CreateProductViewController()
            middleNavVC = UINavigationController(rootViewController: vc)
            middleNavVC.tabBarItem = UITabBarItem(title: "Add Product", image: UIImage(systemName: "plus"), tag: 1)
        } else {
            let vc = CartViewController()
            middleNavVC = UINavigationController(rootViewController: vc)
            middleNavVC.tabBarItem = UITabBarItem(title: "Basket", image: UIImage(systemName: "basket"), tag: 1)
        }
        
        let settingsNavVC = UINavigationController(rootViewController: SettingsViewController())
        settingsNavVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)

        viewControllers = [mainNavVC, middleNavVC, settingsNavVC]
    }
}
