//protocol CartCellViewModelProtocol {
//    var product: CartProduct { get }
//    var quantityChanged: ((Int) -> Void)? { get set }
//
//    func updateQuantity(_ quantity: Int)
//}
//
//final class CartCellViewModel: CartCellViewModelProtocol {
//    var product: CartProduct
//    var quantityChanged: ((Int) -> Void)?
//
//    init(product: CartProduct) {
//        self.product = product
//    }
//
//    func updateQuantity(_ quantity: Int) {
//        product.quantity = quantity
//        quantityChanged?(quantity)
//    }
//}
