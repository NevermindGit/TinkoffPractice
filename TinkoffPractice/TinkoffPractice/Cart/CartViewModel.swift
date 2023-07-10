import Foundation

protocol CartViewModelProtocol: AnyObject {
    var productAdded: (() -> Void)? { get set }
    var numberOfProducts: Int { get }
    func product(at index: Int) -> Product

    func removeProduct(at index: Int)
}

final class CartViewModel: CartViewModelProtocol {
    var productAdded: (() -> Void)?

    var numberOfProducts: Int {
        CartManager.shared.getProduct().count
    }

    func product(at index: Int) -> Product {
        CartManager.shared.getProduct()[index]
    }

    func removeProduct(at index: Int) {
        CartManager.shared.removeProduct(at: index)
        productAdded?()
    }

    init() {
        CartManager.shared.productAdded = { [weak self] _ in
            DispatchQueue.main.async {
                self?.productAdded?()
            }
        }
    }
}


