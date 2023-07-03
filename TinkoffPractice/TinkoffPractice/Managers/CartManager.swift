import Foundation


class CartManager {
    
    static let shared = CartManager()
    private var items: [Item] = []
    var itemAdded: ((Item) -> Void)?

    private init() {}

    func addItem(_ item: Item) {
        items.append(item)
        itemAdded?(item)
    }

    func getItems() -> [Item] {
        return items
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
    }
}
