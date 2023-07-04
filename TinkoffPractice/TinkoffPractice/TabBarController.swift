import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    private func configureViewControllers() {
        let mainNavVC = UINavigationController(rootViewController: MainViewController())
        mainNavVC.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)
        

        let basketNavVC = UINavigationController(rootViewController: CartViewController())
        basketNavVC.tabBarItem = UITabBarItem(title: "Basket", image: UIImage(systemName: "basket"), tag: 1)
        
        let settingsNavVC = UINavigationController(rootViewController: BaseViewController())
        settingsNavVC.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        viewControllers = [mainNavVC, basketNavVC, settingsNavVC]
    }
}
