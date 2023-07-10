import UIKit

protocol OrderItemViewModelProtocol {
    var productImage: UIImage? { get }
    var productName: String { get }
    var productPrice: Double { get }
    var productQuantity: Int { get }
}


final class OrderItemViewModel: OrderItemViewModelProtocol {
    private let cartProduct: CartProduct

    init(cartProduct: CartProduct) {
        self.cartProduct = cartProduct
    }

    var productImage: UIImage? {
        return cartProduct.product.image
    }

    var productName: String {
        return cartProduct.product.name
    }

    var productPrice: Double {
        return cartProduct.product.price
    }

    var productQuantity: Int {
        return cartProduct.quantity
    }
}
