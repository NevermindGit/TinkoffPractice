import Foundation


protocol OrderStatusViewModelProtocol: AnyObject {
    var product: Product { get }
    func getOrderStatus(completion: @escaping((String) -> Void))
    func cancelOrder(completion: @escaping ((Bool) -> Void))
    func getUserRole(completion: @escaping(String) -> Void)
    func getDateLabel() -> String
    func getNextStatus() -> OrderStatus
}

final class OrderStatusViewModel: OrderStatusViewModelProtocol {
    var product: Product

    init(product: Product) {
        self.product = product

    }
    
    private var currentStatus: OrderStatus = .created
    
    func getOrderStatus(completion: @escaping((String) -> Void)) {
        completion("Заказ собран")
    }
    
    func cancelOrder(completion: @escaping ((Bool) -> Void)) {
        completion(true)
    }
    
    func getUserRole(completion: @escaping (String) -> Void) {
        let userRole = DataManager.shared.getUserRole()
        completion(userRole)
    }
    
    func getDateLabel() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return "Дата заказа: \(dateFormatter.string(from: date))"
    }
    
    func getNextStatus() -> OrderStatus {
        switch currentStatus {
        case .created:
            currentStatus = .inDelivery
        case .inDelivery:
            currentStatus = .received
        default: return .created
            
        }
        
        return currentStatus
    }
    
}
