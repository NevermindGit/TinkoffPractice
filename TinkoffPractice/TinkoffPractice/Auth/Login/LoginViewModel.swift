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
        dataManager.checkIfUserExists(login: login, password: password) { success, token, role in
            if success {
                print("Token: \(token)")
                print("Role: \(role)")
                UserCredentials.saveToCoreData(accessToken: token, userRole: role)
                completion(true)
            } else {
                completion(false)
            }
        }
    }

}
