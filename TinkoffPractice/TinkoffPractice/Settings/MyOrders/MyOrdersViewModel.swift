import Foundation


protocol MyOrdersViewModelProtocol: AnyObject {
    func numberOfProducts() -> Int
    func getMyProducts(completion: @escaping (Result<[Order], Error>) -> Void)
    func getMyOrdersCellViewModel(at indexPath: IndexPath) -> MyOrdersCellViewModelProtocol
    func getOrdersStatusViewModel(at indexPath: IndexPath) -> OrderStatusViewModelProtocol
}

final class MyOrdersViewModel: MyOrdersViewModelProtocol {
    private var orders: [Order] = []

    func getMyProducts(completion: @escaping (Result<[Order], Error>) -> Void) {
        if DataManager.shared.getUserRole() == "Покупатель" {
            DataManager.shared.fetchBuyersOrders { [weak self] orders in
                guard let self = self else { return }
                if !orders.isEmpty {
                    self.orders = orders
                    completion(.success(orders))
                } else {
                    let error = NSError(domain: "com.RocketBank.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No orders found"])
                    completion(.failure(error))
                }
            }
        } else {
            DataManager.shared.fetchSellersOrders { [weak self] orders in
                guard let self = self else { return }
                if !orders.isEmpty {
                    self.orders = orders
                    completion(.success(orders))
                } else {
                    let error = NSError(domain: "com.RocketBank.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No orders found"])
                    completion(.failure(error))
                }
            }
        }
    }

    func numberOfProducts() -> Int {
        orders.count
    }
    
    func getMyOrdersCellViewModel(at indexPath: IndexPath) -> MyOrdersCellViewModelProtocol {
        MyOrdersCellViewModel(order: orders[indexPath.row])
    }
    
    func getOrdersStatusViewModel(at indexPath: IndexPath) -> OrderStatusViewModelProtocol {
        OrderStatusViewModel(product: orders[indexPath.row].product)
    }
}

