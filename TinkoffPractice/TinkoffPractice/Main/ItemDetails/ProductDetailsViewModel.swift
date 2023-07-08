import UIKit

protocol ProductDetailsViewModelProtocol {
    init(product: Product)
    var productName: String { get }
    var productPrice: String { get }
    var productDescription: String { get }
    var productImage: UIImage { get }
    var productDidChange: (() -> Void)? { get set }
    func addToCart()
}

final class ProductDetailsViewModel: ProductDetailsViewModelProtocol {

    var productName: String {
        didSet {
            productDidChange?()
        }
    }
    var productPrice: String {
        didSet {
            productDidChange?()
        }
    }
    var productDescription: String {
        didSet {
            productDidChange?()
        }
    }
    var productImage: UIImage {
        didSet {
            productDidChange?()
        }
    }

    var productDidChange: (() -> Void)?

    private let product: Product

    required init(product: Product) {
        self.product = product
        self.productName = product.name
        self.productDescription = product.description
        self.productPrice = "\(product.price)"
        self.productImage = product.image
    }

    func addToCart() {
        let cartProduct = CartProduct(product: product, quantity: 1)
        CartManager.shared.addOrIncreaseProduct(cartProduct)
    }



}
