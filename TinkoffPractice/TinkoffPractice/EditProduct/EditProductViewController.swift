import UIKit


final class EditProductViewController: BaseViewController {
    
    private var viewModel: EditProductViewModelProtocol!
    
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
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var productNameTextField: BaseTextField = createTextField(placeholder: "Название")
    private lazy var productDescriptionTextField: BaseTextField = createTextField(placeholder: "Описание")
    private lazy var productPriceTextField: BaseTextField = createTextField(placeholder: "Цена ₿")
    
    private lazy var editProductButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Сохранить изменения", for: .normal)
        button.addTarget(self, action: #selector(editProductButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let buttonSpacing: CGFloat = 16
    private let buttonHeight: CGFloat = 30
    
    private var categoryButtons: [UIButton] = []

    private func createTextField(placeholder: String) -> BaseTextField {
        let textField = BaseTextField()
        textField.placeholder = placeholder
        return textField
    }
    
    init(viewModel: EditProductViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        // Initialize the text fields with the product details
        productNameTextField.text = viewModel.product.name
        productDescriptionTextField.text = viewModel.product.description
        productPriceTextField.text = "\(viewModel.product.price)"
        imageButton.setImage(viewModel.product.image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    private func editProductButtonDidTap() {
        // Check if any TextField is empty, if it is, return from the function
        guard let productName = productNameTextField.text, !productName.isEmpty,
              let productDescription = productDescriptionTextField.text, !productDescription.isEmpty,
              let productPrice = productPriceTextField.text, !productPrice.isEmpty,
              let productImage = imageButton.image(for: .normal) else {
            showErrorAlert(title: "Ошибка", message: "Все поля должны быть заполнены")
            return
        }
        
        // Check if a category has been selected, if not, return from the function
        guard viewModel.selectedCategory.count > 0 else {
            showErrorAlert(title: "Ошибка", message: "Выберите категорию")
            return
        }
        
        // Update the ViewModel with the new data
        viewModel.product.name = productName
        viewModel.product.description = productDescription
        viewModel.product.price = Double(productPrice) ?? 0.0
        viewModel.product.image = productImage
        viewModel.product.category = viewModel.selectedCategory // Take the first selected category
        
        // Try to edit the product
        viewModel.editProduct { [weak self] success in
            if success {
                self?.dismiss(animated: true)                
            } else {
                self?.showErrorAlert(title: "Ошибка", message: "Возника ошибка при сохранении товара")
            }
        }
    }

    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryButtons()
        setupUI()
    }
    
    private func setupCategoryButtons() {
        var buttonOrigin = CGPoint(x: buttonSpacing, y: 500)

        for category in viewModel.categories {
            let button = BaseButton()
            button.setTitle(category.rawValue, for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.backgroundColor = .systemGray5
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            let buttonWidth = button.intrinsicContentSize.width + 20

            if buttonOrigin.x + buttonWidth > view.bounds.width {
                buttonOrigin.x = buttonSpacing
                buttonOrigin.y += buttonHeight + buttonSpacing
            }

            button.frame = CGRect(x: buttonOrigin.x, y: buttonOrigin.y, width: buttonWidth, height: buttonHeight)
            buttonOrigin.x += buttonWidth + buttonSpacing

            button.addTarget(self, action: #selector(categoriesButtonPressed(_:)), for: .touchUpInside)

            contentView.addSubview(button)

            categoryButtons.append(button)
        }
    }
    
    @objc
    private func categoriesButtonPressed(_ sender: UIButton) {
        // Check if more than one category is already selected
        if viewModel.selectedCategory.count >= 1 && !sender.isSelected {
            // If so, show an alert and return
            showErrorAlert(title: "Ошибка", message: "Можно выбрать только одну категорию")
            return
        }
        
        // Toggle button selected state
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .systemYellow : .systemGray5
        sender.setTitleColor(.black, for: .normal)

        guard let title = sender.currentTitle, let category = Category(rawValue: title) else { return }

        if sender.isSelected {
            viewModel.selectedCategory = category.rawValue
        } else {
            viewModel.selectedCategory = ""
        }
        print(viewModel.selectedCategory)
    }

    
    private func setupUI() {
            
        title = "Изменить"
        navigationItem.largeTitleDisplayMode = .always
        
        // Add scrollView and contentView to the view hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Add your elements to the contentView instead of the view
        contentView.addSubview(imageButton)
        contentView.addSubview(productNameTextField)
        contentView.addSubview(productDescriptionTextField)
        contentView.addSubview(productPriceTextField)
        contentView.addSubview(editProductButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }
        
        imageButton.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView).offset(40)
            make.width.height.equalTo(200)
        }
        
        productNameTextField.snp.makeConstraints { make in
            make.top.equalTo(imageButton.snp.bottom).offset(16)
            make.leading.equalTo(contentView).offset(16)
            make.trailing.equalTo(contentView).offset(-16)
            make.height.equalTo(40)
        }
        
        productDescriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(productNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(productNameTextField)
            make.height.equalTo(100)
        }
        
        productPriceTextField.snp.makeConstraints { make in
            make.top.equalTo(productDescriptionTextField.snp.bottom).offset(16)
            make.leading.trailing.equalTo(productNameTextField)
            make.height.equalTo(40)
        }
        
        if let lastCategoryButton = categoryButtons.last {
            editProductButton.snp.makeConstraints { make in
                make.width.equalTo(view.snp.width).multipliedBy(0.9)
                make.height.equalTo(56)
                make.top.equalTo(lastCategoryButton.snp.bottom).offset(20)
                make.centerX.equalTo(contentView.snp.centerX)
                make.bottom.equalTo(contentView).offset(-20)  // important for scrollview
            }
        } else {
            editProductButton.snp.makeConstraints { make in
                make.centerX.equalTo(contentView.snp.centerX)
                make.top.equalTo(productPriceTextField.snp.bottom).offset(20)
                make.width.equalTo(view.snp.width).multipliedBy(0.9)
                make.height.equalTo(56)
                make.bottom.equalTo(contentView).offset(-20)  // important for scrollview
            }
        }
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
