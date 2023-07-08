import Foundation

final class CartManager {
    static let shared = CartManager()
    private var items: [CartProduct] = []
    var productAdded: ((CartProduct) -> Void)?

    private init() {}

    func addOrIncreaseProduct(_ item: CartProduct) {
        if let index = items.firstIndex(where: { $0.product.id == item.product.id }) {
            items[index].quantity += 1
        } else {
            items.append(item)
        }
        productAdded?(items.last!)
    }

    func getProduct() -> [CartProduct] {
        return items
    }

    func removeProduct(at index: Int) {
        items.remove(at: index)
    }
}

