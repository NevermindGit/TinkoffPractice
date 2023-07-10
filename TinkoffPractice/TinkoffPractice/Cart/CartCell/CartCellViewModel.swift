protocol CartCellViewModelProtocol {
    var product: Product { get }
    var quantityDidChange: ((Int) -> Void)? { get set }
    func increaseQuantity()
    func decreaseQuantity()
}

class CartCellViewModel: CartCellViewModelProtocol {
    var product: Product
    var quantityDidChange: ((Int) -> Void)?

    init(product: Product) {
        self.product = product
    }

    func increaseQuantity() {
        product.quantity += 1
        quantityDidChange?(product.quantity)
    }

    func decreaseQuantity() {
        if product.quantity > 1 {
            product.quantity -= 1
            quantityDidChange?(product.quantity)
        }
    }
}
