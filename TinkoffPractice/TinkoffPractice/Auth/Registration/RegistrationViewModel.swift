import Foundation

protocol RegistrationViewModelProtocol {
    var registerButtonButtonTapped: (() -> Void)? { get set }
    func addUserToDatabase(login: String, username: String, password: String, userType: String, completion: @escaping((Bool) -> Void))
}

final class RegistrationViewModel: RegistrationViewModelProtocol {
    private let dataManager: DataManagerProtocol

    var registerButtonButtonTapped: (() -> Void)?

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }

    func addUserToDatabase(login: String, username: String, password: String, userType: String, completion: @escaping((Bool) -> Void)) {
        dataManager.addUserToDatabase(login: login, username: username, password: password, userType: userType) { success in
            completion(true)
        }
    }
}
