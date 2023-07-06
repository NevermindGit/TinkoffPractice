import UIKit
import SnapKit

final class CreateProductViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    private lazy var createProductButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Создать товар", for: .normal)
        button.addTarget(self, action: #selector(createProductButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func createTextField(placeholder: String) -> BaseTextField {
        let textField = BaseTextField()
        textField.placeholder = placeholder
        return textField
    }
    
    private func setupUI() {
        
        title = "Добавить"
        navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(imageButton)
        view.addSubview(productNameTextField)
        view.addSubview(productDescriptionTextField)
        view.addSubview(productPriceTextField)
        view.addSubview(createProductButton)
        
        imageButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.width.height.equalTo(200)
        }
        
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        productDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(productNameTextField)
            make.height.equalTo(100)
        }
        
        productPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionTextField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(productNameTextField)
            make.height.equalTo(40)
        }
        
        createProductButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(56)
        }
    }
    
    @objc
    private func cameraButtonDidTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageButton.setImage(pickedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func createProductButtonDidTap() {
        
    }
}
