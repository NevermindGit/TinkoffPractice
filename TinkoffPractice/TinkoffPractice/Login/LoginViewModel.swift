import Foundation



protocol LoginViewModelProtocol: AnyObject {
    var loginButtonTapped: (() -> Void)? { get set }
    var goToRegistrationButtonTapped: (() -> Void)? { get set }
    func performLogin(login: String, password: String, completion: @escaping (Bool) -> Void)
}


class LoginViewModel: LoginViewModelProtocol {
    
    private let dataManager: DataManagerProtocol
    
    var loginButtonTapped: (() -> Void)?
    var goToRegistrationButtonTapped: (() -> Void)?
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func performLogin(login: String, password: String, completion: @escaping (Bool) -> Void) {
        dataManager.checkIfUserExists(login: login, password: password) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
}
