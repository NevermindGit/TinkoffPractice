import Foundation


protocol MainViewModelProtocol: AnyObject {
    func fetchProductsFromServer(completion: @escaping (Result<[Item], Error>) -> Void)
    func numberOfRows() -> Int
    func getProductsCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getProductsDetailsViewModel(at indexPath: IndexPath) -> ItemDetailsViewModelProtocol
}


final class MainViewModel: MainViewModelProtocol {
    
    private let dataManager: DataManagerProtocol
    
    private var items: [Item] = []
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func fetchProductsFromServer(completion: @escaping (Result<[Item], Error>) -> Void) {
        dataManager.fetchAllItems { [weak self] items in
            guard let self = self else { return }
            if !items.isEmpty {
                self.items = items
                completion(.success(items))
                print("Got Items from DB")
            } else {
                let error = NSError(domain: "com.RocketBank.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No products found"])
                completion(.failure(error))
            }
        }
    }
    
    func numberOfRows() -> Int {
        items.count
    }
    
    func getProductsCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol {
        ItemCellViewModel(item: items[indexPath.row])
    }
    
    func getProductsDetailsViewModel(at indexPath: IndexPath) -> ItemDetailsViewModelProtocol {
        ItemDetailsViewModel(item: items[indexPath.row])
    }
    
}
