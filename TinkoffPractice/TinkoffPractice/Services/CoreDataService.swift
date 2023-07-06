import UIKit
import CoreData

public final class CoreDataService: NSObject {
    public static let shared = CoreDataService()
    private override init() {}

    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    }

    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }

    public func saveObject<T: NSManagedObject>(_ object: T.Type, attributes: [String: Any]) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: T.self), in: context) else {
            return
        }
        let newObject = T(entity: entityDescription, insertInto: context)
        for (key, value) in attributes {
            newObject.setValue(value, forKey: key)
        }
        appDelegate.saveContext()
    }

    public func fetchAllObjects<T: NSManagedObject>(_ object: T.Type) -> [T] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        return (try? context.fetch(fetchRequest) as? [T]) ?? []
    }

    public func fetchObject<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate) -> T? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        return (try? context.fetch(fetchRequest) as? [T])?.first
    }

    public func updateObject<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate, newValues: [String: Any]) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        guard let objects = try? context.fetch(fetchRequest) as? [T],
              let objectToUpdate = objects.first else { return }

        for (key, value) in newValues {
            objectToUpdate.setValue(value, forKey: key)
        }
        appDelegate.saveContext()
    }

    public func deleteAllObjects<T: NSManagedObject>(_ object: T.Type) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        let objects = try? context.fetch(fetchRequest) as? [T]
        objects?.forEach { context.delete($0) }
        appDelegate.saveContext()
    }

    public func deleteObject<T: NSManagedObject>(_ object: T.Type, predicate: NSPredicate) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        guard let objects = try? context.fetch(fetchRequest) as? [T],
              let objectToDelete = objects.first else { return }

        context.delete(objectToDelete)
        appDelegate.saveContext()
    }
}
