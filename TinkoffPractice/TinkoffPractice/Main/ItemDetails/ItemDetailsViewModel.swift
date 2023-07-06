import UIKit

protocol ItemDetailsViewModelProtocol {
    init(item: Item)
    var itemName: String { get }
    var itemPrice: String { get }
    var itemDescription: String { get }
    var itemImage: UIImage { get }
    var itemDidChange: (() -> Void)? { get set }
    func addToCart()
}

final class ItemDetailsViewModel: ItemDetailsViewModelProtocol {

    var itemName: String {
        didSet {
            itemDidChange?()
        }
    }
    var itemPrice: String {
        didSet {
            itemDidChange?()
        }
    }
    var itemDescription: String {
        didSet {
            itemDidChange?()
        }
    }
    var itemImage: UIImage {
        didSet {
            itemDidChange?()
        }
    }

    var itemDidChange: (() -> Void)?

    private let item: Item

    required init(item: Item) {
        self.item = item
        self.itemName = item.name
        self.itemDescription = item.description
        self.itemPrice = "\(item.price)"
        self.itemImage = item.image
    }

    func addToCart() {
        CartManager.shared.addItem(item)
    }

}
