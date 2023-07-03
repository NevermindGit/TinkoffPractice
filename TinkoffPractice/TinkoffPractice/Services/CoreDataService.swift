import UIKit
import CoreData


// MARK: - CRUD
public final class CoreDataService: NSObject {
    public static let shared = CoreDataService()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    

    public func saveUser(_ id: Int16, userInfo: String) {
        guard let userEntityDescription = NSEntityDescription.entity(forEntityName: "User", in: context) else {
            return
        }
        let user = User(entity: userEntityDescription, insertInto: context)
        user.id = id
        user.userInfo = userInfo
        
        appDelegate.saveContext()
    }
    
    public func fetchAllUsers() -> [User] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            return (try? context.fetch(fetchRequest) as? [User]) ?? []
        }
    }
    
    public func fetchUser(with id: Int16) -> User? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let users = try? context.fetch(fetchRequest) as? [User]
            return users?.first
        }
    }
    
    public func updateUser(with id: Int16, newUserInfo: String, password: String? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let users = try? context.fetch(fetchRequest) as? [User],
                  let user = users.first  else { return }
            
            user.userInfo = newUserInfo
            user.password = password
        }
        
        appDelegate.saveContext()
    }
    
    public func deleteAllUsers(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let users = try? context.fetch(fetchRequest) as? [User]
            users?.forEach {context.delete($0) }
        }
        
        appDelegate.saveContext()
    }
    
    public func deleteUser(with id: Int16) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            guard let users = try? context.fetch(fetchRequest) as? [User],
                  let user = users.first  else { return }
            
            context.delete(user)
        }
        
        appDelegate.saveContext()
    }
}
