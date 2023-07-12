import UIKit

protocol CreateProductViewModelProtocol {
    var categories: [Category] { get }
    var selectedCategories: Category.RawValue { get set }
    var productName: String { get }
    var productDescription: String { get }
    var productPrice: String { get }
    var productImage: UIImage { get }
    
    func validateFields() -> Bool
    func createProduct(completion: @escaping (Bool) -> Void)
}

final class CreateProductViewModel: CreateProductViewModelProtocol {
    
    var categories: [Category] = Category.allCases
    var selectedCategories: Category.RawValue = ""
    
    var productName: String
    var productDescription: String
    var productPrice: String
    var productImage: UIImage
    
    init(productName: String, productDescription: String, productPrice: String, productImage: UIImage) {
        self.productName = productName
        self.productDescription = productDescription
        self.productPrice = productPrice
        self.productImage = productImage
    }
    
    func validateFields() -> Bool {
        if productName.isEmpty || productDescription.isEmpty || productPrice.isEmpty || productImage == UIImage() {
            return false
        }
        
        if let _ = Double(productPrice) {
            return true
        } else {
            return false
        }
    }
    
    func createProduct(completion: @escaping (Bool) -> Void) {
        DataManager.shared.createProduct(image: productImage, name: productName, description: productDescription, price: productPrice) { success in
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    print("Error creating product")
                    completion(false)
                }
            }
        }
    }
}

