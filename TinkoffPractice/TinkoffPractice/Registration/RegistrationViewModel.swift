import Foundation


protocol RegistrationViewModelProtocol {
    var registerButtonButtonTapped: (() -> Void)? { get set }
    func addUserToDatabase(login: String, userInfo: String, password: String) -> Void
    var userRole: UserRoles { get set }
}


final class RegistrationViewModel: RegistrationViewModelProtocol {
    private let dataManager: DataManagerProtocol
    
    var registerButtonButtonTapped: (() -> Void)?
    
    var userRole: UserRoles = .none
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func addUserToDatabase(login: String, userInfo: String, password: String) -> Void {
        dataManager.addUserToDatabase(login: login, userInfo: userInfo, password: password, userRole: userRole)
    }
}

