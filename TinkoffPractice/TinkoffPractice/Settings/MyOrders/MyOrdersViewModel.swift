import Foundation


protocol MyOrdersViewModelProtocol: AnyObject {
    func numberOfProducts() -> Int
    func getMyProducts(completion: @escaping (Result<[Product], Error>) -> Void)
    func getMyOrdersCellViewModel(at indexPath: IndexPath) -> MyOrdersCellViewModelProtocol
    func getOrdersStatusViewModel(at indexPath: IndexPath) -> OrderStatusViewModelProtocol
}

final class MyOrdersViewModel: MyOrdersViewModelProtocol {
    private var products: [Product] = []

    func getMyProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        if DataManager.shared.getUserRole() == "Покупатель" {
            DataManager.shared.fetchBuyersOrders { [weak self] products in
                guard let self = self else { return }
                if !products.isEmpty {
                    self.products = products
                    completion(.success(products))
                } else {
                    let error = NSError(domain: "com.RocketBank.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No articles found"])
                    completion(.failure(error))
                }
            }
        } else {
            DataManager.shared.fetchSellersOrders { [weak self] products in
                guard let self = self else { return }
                if !products.isEmpty {
                    self.products = products
                    completion(.success(products))
                } else {
                    let error = NSError(domain: "com.RocketBank.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No articles found"])
                    completion(.failure(error))
                }
            }
        }
    }

    func numberOfProducts() -> Int {
        products.count
    }
    
    func getMyOrdersCellViewModel(at indexPath: IndexPath) -> MyOrdersCellViewModelProtocol {
        MyOrdersCellViewModel(product: products[indexPath.row])
    }
    
    func getOrdersStatusViewModel(at indexPath: IndexPath) -> OrderStatusViewModelProtocol {
        OrderStatusViewModel(product: products[indexPath.row])
    }
}
