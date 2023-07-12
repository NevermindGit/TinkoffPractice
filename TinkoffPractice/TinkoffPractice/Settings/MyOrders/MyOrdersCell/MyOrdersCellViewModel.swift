import UIKit

protocol MyOrdersCellViewModelProtocol: AnyObject {
    var itemName: String { get }
    var itemImage: UIImage { get }
    var itemPrice: String { get }
    var itemQuantity: String { get }
    
    init(order: Order)
    
}

final class MyOrdersCellViewModel: MyOrdersCellViewModelProtocol {
    
    private let order: Order
    
    required init(order: Order) {
        self.order = order
    }
    
    var itemName: String {
        order.product.name
    }
    
    var itemImage: UIImage {
        order.product.image
    }
    
    var itemPrice: String {
        String(order.product.price)
    }
    
    var itemQuantity: String {
        "x\(order.product.quantity)"
    }
    
}



