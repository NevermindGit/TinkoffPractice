struct UserCredentials {
    let accessToken: String
    let userRole: String
}

extension UserCredentials {
    static func saveToCoreData(accessToken: String, userRole: String) {
        CoreDataService.shared.saveObject(Credentials.self, attributes: ["accessToken": accessToken, "userRole": userRole])
    }
    
    static func loadFromCoreData() -> UserCredentials? {
        let savedCredentials = CoreDataService.shared.fetchAllObjects(Credentials.self)
        guard let firstSavedCredential = savedCredentials.first else { return nil }
        return UserCredentials(accessToken: firstSavedCredential.accessToken!, userRole: firstSavedCredential.userRole!)
    }

    static func deleteFromCoreData() {
        CoreDataService.shared.deleteAllObjects(Credentials.self)
    }
}
