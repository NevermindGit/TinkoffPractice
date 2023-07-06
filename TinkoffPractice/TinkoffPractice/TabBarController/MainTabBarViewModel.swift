import UIKit


protocol MainTabBarViewModelProtocol {
    func getViewControllers(for role: String) -> [UIViewController]
}

final class MainTabBarViewModel: MainTabBarViewModelProtocol {
    
    func getViewControllers(for role: String) -> [UIViewController] {
        let mainNavVC = UINavigationController(rootViewController: MainViewController())
        mainNavVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), tag: 0)
        mainNavVC.navigationBar.prefersLargeTitles = true

        let middleNavVC: UINavigationController
        if role == "Продавец" {
            let vc = CreateProductViewController()
            middleNavVC = UINavigationController(rootViewController: vc)
            middleNavVC.tabBarItem = UITabBarItem(title: "Добавить", image: UIImage(systemName: "plus.circle"), tag: 1)
            middleNavVC.navigationBar.prefersLargeTitles = true
        } else {
            let vc = CartViewController()
            middleNavVC = UINavigationController(rootViewController: vc)
            middleNavVC.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "basket"), tag: 1)
            middleNavVC.navigationBar.prefersLargeTitles = true
        }
        
        let settingsNavVC = UINavigationController(rootViewController: SettingsViewController())
        settingsNavVC.tabBarItem = UITabBarItem(title: "Настройки", image: UIImage(systemName: "gearshape"), tag: 2)
        settingsNavVC.navigationBar.prefersLargeTitles = true

        return [mainNavVC, middleNavVC, settingsNavVC]
    }
}
