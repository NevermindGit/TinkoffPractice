import UIKit


final class EditProductViewController: BaseViewController {
    
    private lazy var imageButton: UIButton = {
        let button = UIButton()
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        let image = UIImage(systemName: "camera.fill", withConfiguration: symbolConfiguration)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .systemGray
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        button.imageView?.clipsToBounds = true
        button.layer.cornerRadius = 14
        button.imageView?.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(cameraButtonDidTap), for: .touchUpInside)
        return button
    }()

    private lazy var productNameTextField: BaseTextField = createTextField(placeholder: "Название")
    private lazy var productDescriptionTextField: BaseTextField = createTextField(placeholder: "Описание")
    private lazy var productPriceTextField: BaseTextField = createTextField(placeholder: "Цена ₿")

    private func createTextField(placeholder: String) -> BaseTextField {
        let textField = BaseTextField()
        textField.placeholder = placeholder
        return textField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension EditProductViewController: UINavigationControllerDelegate {
    @objc
    private func cameraButtonDidTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate

extension EditProductViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageButton.setImage(pickedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
