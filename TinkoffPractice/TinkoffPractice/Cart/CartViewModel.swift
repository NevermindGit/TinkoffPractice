import Foundation

protocol CartViewModelProtocol: AnyObject {
    var numberOfItems: Int { get }
    var itemAdded: (() -> Void)? { get set }

    func item(at index: Int) -> Item
    func removeItem(at index: Int)
}

final class CartViewModel: CartViewModelProtocol {
    var itemAdded: (() -> Void)?

    var numberOfItems: Int {
        CartManager.shared.getItems().count
    }

    func item(at index: Int) -> Item {
        CartManager.shared.getItems()[index]
    }

    func removeItem(at index: Int) {
        CartManager.shared.removeItem(at: index)
        itemAdded?()
    }

    init() {
        CartManager.shared.itemAdded = { [weak self] _ in
            DispatchQueue.main.async {
                self?.itemAdded?()
            }
        }
    }
}
