import Foundation


protocol OrderHasBeenPaidViewModelProtocol: AnyObject {
    var numberOfItems: Int { get }
    func item(at index: Int) -> Product
    func getDateLabel() -> String
    func getOrdersStatusViewModel(at indexPath: IndexPath) -> OrderStatusViewModelProtocol
}

final class OrderHasBeenPaidViewModel: OrderHasBeenPaidViewModelProtocol {
    
    var numberOfItems: Int {
        CartManager.shared.getProduct().count
    }

    func item(at index: Int) -> Product {
        CartManager.shared.getProduct()[index]
    }
    
    func getDateLabel() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return "Дата заказа: \(dateFormatter.string(from: date))"
    }
    
    func getOrdersStatusViewModel(at indexPath: IndexPath) -> OrderStatusViewModelProtocol {
        OrderStatusViewModel(product: item(at: indexPath.row))
    }
    
    
}
