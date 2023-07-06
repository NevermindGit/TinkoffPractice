import Foundation

protocol MainViewModelProtocol: AnyObject {
    func fetchProductsFromServer(completion: @escaping (Result<[Item], Error>) -> Void)
    func numberOfRows() -> Int
    func getProductsCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol
    func getProductsDetailsViewModel(at indexPath: IndexPath) -> ItemDetailsViewModelProtocol
    func filterItems(with searchText: String, completion: @escaping () -> Void)
}

final class MainViewModel: MainViewModelProtocol {

    private let dataManager: DataManagerProtocol

    private var items: [Item] = []

    private var searchedItems: [Item]?

    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }

    func filterItems(with searchText: String, completion: @escaping () -> Void) {
        if searchText.isEmpty {
            searchedItems = nil
        } else {
            searchedItems = items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        completion()
    }

    func fetchProductsFromServer(completion: @escaping (Result<[Item], Error>) -> Void) {
        dataManager.fetchAllItems { [weak self] items in
            guard let self = self else { return }
            if !items.isEmpty {
                self.items = items
                completion(.success(items))
                print("Got Items from DB")
            } else {
                let error = NSError(domain: "com.RocketBank.app",
                                    code: 0, userInfo: [NSLocalizedDescriptionKey: "No products found"])
                completion(.failure(error))
            }
        }
    }

    func numberOfRows() -> Int {
        searchedItems?.count ?? items.count
    }

    func getProductsCellViewModel(at indexPath: IndexPath) -> ItemCellViewModelProtocol {
        ItemCellViewModel(item: getItem(at: indexPath))
    }

    func getProductsDetailsViewModel(at indexPath: IndexPath) -> ItemDetailsViewModelProtocol {
        ItemDetailsViewModel(item: getItem(at: indexPath))
    }

    private func getItem(at indexPath: IndexPath) -> Item {
        if let searchedItems = searchedItems {
            return searchedItems[indexPath.row]
        } else {
            return items[indexPath.row]
        }
    }

}
