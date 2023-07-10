import UIKit

protocol MyOrdersCellViewModelProtocol: AnyObject {
    var itemName: String { get }
    var itemImage: UIImage { get }
    var itemPrice: String { get }
    var itemQuantity: String { get }
    
    init(product: Product)
    
}

final class MyOrdersCellViewModel: MyOrdersCellViewModelProtocol {
    
    private let product: Product
    
    required init(product: Product) {
        self.product = product
    }
    
    var itemName: String {
        product.name
    }
    
    var itemImage: UIImage {
        product.image
    }
    
    var itemPrice: String {
        String(product.price)
    }
    
    var itemQuantity: String {
        "x\(product.quantity)"
    }
    
}


