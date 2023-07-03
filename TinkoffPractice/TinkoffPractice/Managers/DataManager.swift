import Foundation
import UIKit


protocol DataManagerProtocol: AnyObject {
    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: UserRoles) -> Void
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool) -> Void)
    func fetchAllItems(completion: @escaping (([Item]) -> Void))
    func fetchItemsWithFilter(minPrice: Double, maxPrice: Double, categories: [String], completion: @escaping (([Item]) -> Void))
}


final class DataManager: DataManagerProtocol{
    public static let shared = DataManager()
    private init() {}
    
    func addUserToDatabase(login: String, userInfo: String, password: String, userRole: UserRoles) -> Void {
        print("User \(login) was added to DB")
    }
    
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool) -> Void) {
        if !login.isEmpty && !password.isEmpty{
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func fetchAllItems(completion: @escaping (([Item]) -> Void)) {
        let item1 = Item(id: 1, name: "Product 1", price: 10.0, image: UIImage(named: "vans") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        let item2 = Item(id: 2, name: "New Item", price: 20.0, image: UIImage(named: "nike") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        let item3 = Item(id: 3, name: "Blazer", price: 100.0, image: UIImage(named: "blazer") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        let item4 = Item(id: 4, name: "Product 4", price: 250.0, image: UIImage(named: "nike") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        let item5 = Item(id: 5, name: "Vans", price: 20.0, image: UIImage(named: "vans") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        let item6 = Item(id: 6, name: "Product 3", price: 100.0, image: UIImage(named: "blazer") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        let item7 = Item(id: 7, name: "Product 4", price: 250.0, image: UIImage(named: "nike") ?? UIImage(), description: "DLKFJALKFJSAD;LFASJFNSFD")
        print("Fetch items from DB")
        completion([item1, item2, item3, item4, item5, item6, item7])
    }
    
    func fetchItemsWithFilter(minPrice: Double, maxPrice: Double, categories: [String], completion: @escaping (([Item]) -> Void)) {
        
    }

}
