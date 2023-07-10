protocol OrderStatusViewModelProtocol: AnyObject {
    var product: CartProduct { get }
    func getOrderStatus(completion: @escaping((String) -> Void))
    func cancelOrder(completion: @escaping ((Bool) -> Void))
}

final class OrderStatusViewModel: OrderStatusViewModelProtocol {
    var product: CartProduct

    init(product: CartProduct) {
        self.product = product

    }
    
    func getOrderStatus(completion: @escaping((String) -> Void)) {
        completion("Заказ собран")
    }
    
    func cancelOrder(completion: @escaping ((Bool) -> Void)) {
        completion(true)
    }
}
