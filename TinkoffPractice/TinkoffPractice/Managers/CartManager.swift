import Foundation

final class CartManager {
    static let shared = CartManager()
    private var items: [Product] = []
    var productAdded: ((Product) -> Void)?

    private init() {}

    func addOrIncreaseProduct(_ item: Product) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += 1
        } else {
            items.append(item)
        }
        productAdded?(items.last!)
    }

    func getProduct() -> [Product] {
        return items
    }

    func removeProduct(at index: Int) {
        items.remove(at: index)
    }
}

