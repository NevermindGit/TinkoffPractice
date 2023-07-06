import Foundation

protocol RegistrationViewModelProtocol {
    var registerButtonButtonTapped: (() -> Void)? { get set }
    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: String)
}

final class RegistrationViewModel: RegistrationViewModelProtocol {
    private let dataManager: DataManagerProtocol

    var registerButtonButtonTapped: (() -> Void)?

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }

    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: String) {
        dataManager.addUserToDatabase(login: login, userInfo: userInfo, password: password, userRole: userRole)
    }
}
