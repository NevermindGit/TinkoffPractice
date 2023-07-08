final class CartProduct {
    var product: Product
    var quantity: Int {
        didSet {
            CartManager.shared.productAdded?(self)
        }
    }

    init(product: Product, quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
