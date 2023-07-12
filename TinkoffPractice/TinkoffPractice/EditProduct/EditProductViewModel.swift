import UIKit


protocol EditProductViewModelProtocol {
    var categories: [Category] { get }
    var selectedCategory: Category.RawValue { get set }
    init(product: Product)
    var product: Product { get set }
    var productDidChange: (() -> Void)? { get set }
    func editProduct(completion: @escaping (Bool) -> Void)
}

final class EditProductViewModel: EditProductViewModelProtocol {
    var categories: [Category] = Category.allCases
    var selectedCategory: Category.RawValue = ""
    
    var product: Product {
        didSet {
            productDidChange?()
        }
    }

    var productDidChange: (() -> Void)?

    required init(product: Product) {
        self.product = product
    }
    
    func editProduct(completion: @escaping (Bool) -> Void) {
        print(product.category)
        DataManager.shared.editProduct(image: product.image, name: product.name, description: product.description, price: String(product.price), category: selectedCategory) { success in
            if success {
                self.productDidChange?()
                completion(true)
            } else {
                print("Error creating product")
                completion(false)
            }
            
        }
    }
   
}
