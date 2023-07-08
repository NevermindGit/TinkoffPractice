import Foundation
import UIKit
import Alamofire

protocol DataManagerProtocol: AnyObject {
    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: String)
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool, String, String) -> Void)
    func fetchAllItems(completion: @escaping (([Product]) -> Void))
    func fetchItemsWithFilter(
        minPrice: Double, maxPrice: Double, сategories: [String],
        completion: @escaping (([Product]) -> Void)
    )
}

final class DataManager: DataManagerProtocol {
    public static let shared = DataManager()
    private init() {}
    
    private let host = "http://127.0.0.1:5001"

    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: String) {
        print("User \(login) with role \(userRole) was added to DB")
    }
    
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool, String, String) -> Void) {
        let parameters: Parameters = ["username": login, "password": password]
        
        BackendService.shared.sendRequest(endpoint: "\(host)/login", method: .post, parameters: parameters) { data, response, error in
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


    func fetchAllItems(completion: @escaping (([Product]) -> Void)) {
        let item1 = Product(
            id: 1, name: "Product 1", price: 10.0,
            image: UIImage(named: "vans") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        let item2 = Product(
            id: 2, name: "New Item", price: 20.0,
            image: UIImage(named: "nike") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        let item3 = Product(
            id: 3, name: "Blazer", price: 100.0,
            image: UIImage(named: "blazer") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        let item4 = Product(
            id: 4, name: "Product 4", price: 250.0,
            image: UIImage(named: "nike") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        let item5 = Product(
            id: 5, name: "Vans", price: 20.0,
            image: UIImage(named: "vans") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        let item6 = Product(
            id: 6, name: "Product 3", price: 100.0,
            image: UIImage(named: "blazer") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        let item7 = Product(
            id: 7, name: "Product 4", price: 250.0,
            image: UIImage(named: "nike") ?? UIImage(),
            description: "DLKFJALKFJSAD;LFASJFNSFD", category: "1"
        )
        print("Fetch items from DB")
        completion([item1, item2, item3, item4, item5, item6, item7])
    }

    func fetchItemsWithFilter(
        minPrice: Double, maxPrice: Double, сategories: [String],
        completion: @escaping (([Product]) -> Void)
    ) {

    }
    
    func getUserRole() -> String {
        UserCredentials.loadFromCoreData()?.userRole ?? "none"
    }
    
    func createProduct(image: UIImage, name: String, description: String,
                       price: String, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(false)
            return
        }

        // Convert the image to a Base64 string
        let base64Image = imageData.base64EncodedString()

        let parameters: [String: Any] = [
            "name": name,
            "description": description,
            "price": price,
            "photo": base64Image
        ]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(String(describing: UserCredentials.loadFromCoreData()?.accessToken))",
            "Content-type": "application/json"
        ]

        BackendService.shared.sendRequest(endpoint: "http://127.0.0.1:5001/api/create_product",
                                          method: .post, parameters: parameters, headers: headers)
        { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
            } else if let response = response, (200..<300).contains(response.statusCode) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }




}
