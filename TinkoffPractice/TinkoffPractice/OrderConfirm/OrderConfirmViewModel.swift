import Foundation

protocol OrderConfirmViewModelProtocol {
    var numberOfItems: Int { get }
    func item(at index: Int) -> CartProduct
}

final class OrderConfirmViewModel: OrderConfirmViewModelProtocol {

    var numberOfItems: Int {
        CartManager.shared.getProduct().count
    }

    func item(at index: Int) -> CartProduct {
        CartManager.shared.getProduct()[index]
    }
}
