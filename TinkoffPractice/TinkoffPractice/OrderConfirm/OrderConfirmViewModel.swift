import Foundation

protocol OrderConfirmViewModelProtocol {
    var numberOfItems: Int { get }
    func item(at index: Int) -> Product
    func totalSum() -> Double
}

final class OrderConfirmViewModel: OrderConfirmViewModelProtocol {

    var numberOfItems: Int {
        CartManager.shared.getProduct().count
    }

    func item(at index: Int) -> Product {
        CartManager.shared.getProduct()[index]
    }
    
    func totalSum() -> Double {
        return CartManager.shared.getProduct().reduce(0) { $0 + $1.price * Double($1.quantity) }
    }
}
