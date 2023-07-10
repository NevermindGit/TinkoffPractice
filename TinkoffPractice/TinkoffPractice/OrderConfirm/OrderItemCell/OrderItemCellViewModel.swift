import UIKit

protocol OrderItemViewModelProtocol {
    var productImage: UIImage? { get }
    var productName: String { get }
    var productPrice: Double { get }
    var productQuantity: Int { get }
}


final class OrderItemViewModel: OrderItemViewModelProtocol {
    private let product: Product

    init(product: Product) {
        self.product = product
    }

    var productImage: UIImage? {
        return product.image
    }

    var productName: String {
        return product.name
    }

    var productPrice: Double {
        return product.price
    }

    var productQuantity: Int {
        return product.quantity
    }
}
