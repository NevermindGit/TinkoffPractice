protocol FilterViewModelProtocol {
    var categories: [Category] { get }
    var selectedCategories: [Category] { get set }
    var minPrice: Double? { get set }
    var maxPrice: Double? { get set }
    var onSave: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
    
    func saveFilter()
}

final class FilterViewModel: FilterViewModelProtocol {
    var categories: [Category] = Category.allCases
    var selectedCategories: [Category] = []
    var minPrice: Double?
    var maxPrice: Double?
    var onSave: (() -> Void)?
    var onError: ((Error) -> Void)?

    func saveFilter() {
        if let minPrice = minPrice, let maxPrice = maxPrice, minPrice > maxPrice {
            onError?(FilterError.invalidPriceRange)
            return
        }

        // Тут сохраните ваши фильтры...

        // После успешного сохранения вызовите замыкание onSave
        onSave?()
    }
}

enum FilterError: Error {
    case invalidPriceRange
}
