import UIKit


protocol MainTabBarViewModelProtocol {
    func getViewControllers(for role: String) -> [UIViewController]
}

class MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    func getViewControllers(for role: String) -> [UIViewController] {
        let mainNavVC = UINavigationController(rootViewController: MainViewController())
        mainNavVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)

        let middleNavVC: UINavigationController
        if role == "продавец" {
            let vc = CreateProductViewController()
            middleNavVC = UINavigationController(rootViewController: vc)
            middleNavVC.tabBarItem = UITabBarItem(title: "Добавить", image: UIImage(systemName: "plus.circle"), tag: 1)
        } else {
            let vc = CartViewController()
            middleNavVC = UINavigationController(rootViewController: vc)
            middleNavVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "basket"), tag: 1)
        }
        
        let settingsNavVC = UINavigationController(rootViewController: SettingsViewController())
        settingsNavVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 2)

        return [mainNavVC, middleNavVC, settingsNavVC]
    }
}
