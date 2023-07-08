import UIKit

protocol ItemCellViewModelProtocol: AnyObject {
    var itemName: String { get }
    var itemPrice: Double { get }
    var itemImage: UIImage { get }
    init(item: Product)
}

final class ItemCellViewModel: ItemCellViewModelProtocol {

    var itemName: String {
        item.name
    }

    var itemPrice: Double {
        item.price
    }

    var itemImage: UIImage {
        item.image
    }

    private let item: Product

    init(item: Product) {
        self.item = item
    }
}
