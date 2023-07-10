import UIKit

protocol MyOrdersCellViewModelProtocol: AnyObject {
    var itemName: String { get }
    var itemImage: UIImage { get }
    var itemPrice: String { get }
    var itemQuantity: String { get }
    
    init(product: CartProduct)
    
}

final class MyOrdersCellViewModel: MyOrdersCellViewModelProtocol {
    
    private let product: CartProduct
    
    required init(product: CartProduct) {
        self.product = product
    }
    
    var itemName: String {
        product.product.name
    }
    
    var itemImage: UIImage {
        product.product.image
    }
    
    var itemPrice: String {
        String(product.product.price)
    }
    
    var itemQuantity: String {
        "x\(product.quantity)"
    }
    
}


