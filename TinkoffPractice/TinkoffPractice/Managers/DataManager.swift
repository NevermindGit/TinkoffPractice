import Foundation
import UIKit
import Alamofire

protocol DataManagerProtocol: AnyObject {
    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: String)
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool, String, String) -> Void)
    func fetchAllItems(completion: @escaping (([Item]) -> Void))
    func fetchItemsWithFilter(
        minPrice: Double, maxPrice: Double, сategories: [String],
        completion: @escaping (([Item]) -> Void)
    )
}

final class DataManager: DataManagerProtocol {
    public static let shared = DataManager()
    private init() {}

    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: String) {
        print("User \(login) with role \(userRole) was added to DB")
    }
    
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool, String, String) -> Void) {
        let endpoint = "http://127.0.0.1:5001/login"
        let parameters: Parameters = ["username": login, "password": password]
        
        BackendService.shared.sendRequest(endpoint: endpoint, method: .post, parameters: parameters) { data, response, error in
            if let error = error {
                print("Произошла ошибка: \(error)")
                completion(false, "", "")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                        let token = json["access_token"] ?? ""
                        let role = json["role"] ?? ""
                        DispatchQueue.main.async {
                            completion(true, token, role)
                        }
                    }
                } catch {
                    print("Ошибка при декодировании данных: \(error)")
                    completion(false, "", "")
                }
            }
        }
    }


    func fetchAllItems(completion: @escaping (([Item]) -> Void)) {
        let item1 = Item(
            id: 1, name: "Product 1", price: 10.0,
            image: UIImage(named: "vans") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        let item2 = Item(
            id: 2, name: "New Item", price: 20.0,
            image: UIImage(named: "nike") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        let item3 = Item(
            id: 3, name: "Blazer", price: 100.0,
            image: UIImage(named: "blazer") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        let item4 = Item(
            id: 4, name: "Product 4", price: 250.0,
            image: UIImage(named: "nike") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        let item5 = Item(
            id: 5, name: "Vans", price: 20.0,
            image: UIImage(named: "vans") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        let item6 = Item(
            id: 6, name: "Product 3", price: 100.0,
            image: UIImage(named: "blazer") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        let item7 = Item(
            id: 7, name: "Product 4", price: 250.0,
            image: UIImage(named: "nike") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD"
        )
        print("Fetch items from DB")
        completion([item1, item2, item3, item4, item5, item6, item7])
    }

    func fetchItemsWithFilter(
        minPrice: Double, maxPrice: Double, сategories: [String],
        completion: @escaping (([Item]) -> Void)
    ) {

    }
    
    func getUserRole() -> String {
        UserCredentials.loadFromCoreData()?.userRole ?? "none"
    }

}
