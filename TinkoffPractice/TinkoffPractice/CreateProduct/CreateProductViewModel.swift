import UIKit


protocol CreateProductViewModelProtocol: AnyObject {
    var onImageSelection: ((UIImage) -> Void)? { get set }
    var onProductCreation: ((Bool) -> Void)? { get set }
    
    func selectImage()
    func createProduct(name: String?, description: String?, price: String?, image: UIImage?)
}

final class CreateProductViewModel: CreateProductViewModelProtocol {
    var onImageSelection: ((UIImage) -> Void)?
    var onProductCreation: ((Bool) -> Void)?

    func selectImage() {
        
    }

    func createProduct(name: String?, description: String?, price: String?, image: UIImage?) {
        guard let name = name, !name.isEmpty,
              let description = description, !description.isEmpty,
              let priceString = price, !priceString.isEmpty,
              let price = Double(priceString),
              let image = image else {
            onProductCreation?(false)
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }

        let productAttributes: [String: Any] = [
            "id": Int16.random(in: Int16.min...Int16.max),
            "name": name,
            "price": price,
            "description": description,
            "image": imageData
        ]

        onProductCreation?(true)
    }
}
