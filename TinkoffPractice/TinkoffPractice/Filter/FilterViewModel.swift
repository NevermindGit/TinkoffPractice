protocol FilterViewModelProtocol {
    var categories: [Category] { get }
    var selectedCategories: [Category.RawValue] { get set }
    var minPrice: Double? { get set }
    var maxPrice: Double? { get set }
    var onSave: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    var sellers: [Seller] { get }
    var selectedSellers: [Seller] { get set }
    func getAllSellers(completion: @escaping ([Seller]) -> Void)
    func saveFilter()
}

final class FilterViewModel: FilterViewModelProtocol {
    var categories: [Category] = Category.allCases
    var selectedCategories: [Category.RawValue] = []
    
    var sellers: [Seller] = []
    var selectedSellers: [Seller] = []
    
    var minPrice: Double?
    var maxPrice: Double?
    var onSave: (() -> Void)?
    var onError: ((Error) -> Void)?

    func saveFilter() {
        if let minPrice = minPrice, let maxPrice = maxPrice, minPrice > maxPrice {
            onError?(FilterError.invalidPriceRange)
            return
        }
        
        let sellerIds = selectedSellers.map { $0.id }
        
        DataManager.shared.fetchItemsWithFilter(minPrice: minPrice ?? 0.0, maxPrice: maxPrice ?? 0.0, сategories: selectedCategories, sellersId: sellerIds) { products in
            
        }
        onSave?()
    }
    
    func getAllSellers(completion: @escaping ([Seller]) -> Void) {
        DataManager.shared.getAllSellers { [weak self] sellers in
            self?.sellers = sellers
            completion(sellers)
        }
    }

}

enum FilterError: Error {
    case invalidPriceRange
}
