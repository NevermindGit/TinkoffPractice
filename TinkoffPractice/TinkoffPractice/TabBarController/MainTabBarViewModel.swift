import UIKit


protocol MainTabBarViewModelProtocol {
    func getViewControllers(for role: String) -> [UIViewController]
}

class MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    func getViewControllers(for role: String) -> [UIViewController] {
        let mainNavVC = UINavigationController(rootViewController: MainViewController())
        mainNavVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)

        let middleNavVC: UINavigationController
        if role == "продавец" {
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

        return [mainNavVC, middleNavVC, settingsNavVC]
    }
}
