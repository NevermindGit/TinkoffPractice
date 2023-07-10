protocol OrderStatusViewModelProtocol: AnyObject {
    var product: Product { get }
    func getOrderStatus(completion: @escaping((String) -> Void))
    func cancelOrder(completion: @escaping ((Bool) -> Void))
    func getUserRole(completion: @escaping(String) -> Void)
}

final class OrderStatusViewModel: OrderStatusViewModelProtocol {
    var product: Product

    init(product: Product) {
        self.product = product

    }
    
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
}
