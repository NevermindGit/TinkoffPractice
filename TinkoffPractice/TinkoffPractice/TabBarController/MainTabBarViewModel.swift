protocol MainTabBarViewModelProtocol: AnyObject {
    var userRole: String { get set }
    var didChangeUserRole: ((String) -> Void)? { get set }
}

class MainTabBarViewModel: MainTabBarViewModelProtocol {
    var userRole: String = "" {
        didSet {
            self.didChangeUserRole?(userRole)
        }
    }
    var didChangeUserRole: ((String) -> Void)?
}
