import UIKit
import SnapKit

final class FilterViewController: BaseViewController {
    
    private var viewModel: FilterViewModelProtocol!

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Цена, ₿"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private let minPriceTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "от 1"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let maxPriceTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "до 100000"
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Категории"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var saveFilterButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()

    private var categoryButtons: [UIButton] = []

    private var selectedCategories: [String] = []

    private let buttonHeight: CGFloat = 30
    private let buttonSpacing: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        view.addSubview(priceLabel)
        view.addSubview(minPriceTextField)
        view.addSubview(maxPriceTextField)
        view.addSubview(categoriesLabel)
        view.addSubview(saveFilterButton)

        setupCategoryButtons()
        setupConstraints()
    }

    private func bindViewModel() {
        viewModel = FilterViewModel()

        viewModel.onSave = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc
    private func buttonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .systemYellow : .systemGray5

        guard let title = sender.currentTitle, let category = Category(rawValue: title) else { return }

        if sender.isSelected {
            viewModel.selectedCategories.append(category)
        } else {
            if let index = viewModel.selectedCategories.firstIndex(of: category) {
                viewModel.selectedCategories.remove(at: index)
            }
        }
    }
    
    @objc
    private func saveButtonPressed() {

        guard let minPriceText = minPriceTextField.text, let minPrice = Double(minPriceText), !minPriceText.isEmpty else {
            return
        }

        guard let maxPriceText = maxPriceTextField.text, let maxPrice = Double(maxPriceText), !maxPriceText.isEmpty else {
            return
        }

        let alert = UIAlertController(title: "Ошибка", message: "Минимальная цена не может быть меньше 10, а максимальная больше 1 000 000", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        if minPrice < 10 || maxPrice > 1_000_000 {
            present(alert, animated: true)
        } else {
            // Update min and max price values
            viewModel.minPrice = minPrice
            viewModel.maxPrice = maxPrice

            viewModel.saveFilter()
        }

        dismiss(animated: true)
    }



    private func setupCategoryButtons() {
        var buttonOrigin = CGPoint(x: buttonSpacing, y: 170)

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

            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

            view.addSubview(button)

            categoryButtons.append(button)
        }
    }

    private func setupConstraints() {
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(50)
        }

        minPriceTextField.snp.makeConstraints { (make) in
            make.left.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
        }

        maxPriceTextField.snp.makeConstraints { (make) in
            make.left.equalTo(minPriceTextField.snp.right).offset(10)
            make.top.equalTo(minPriceTextField)
            make.right.equalToSuperview().inset(20)
        }

        categoriesLabel.snp.makeConstraints { make in
            make.left.equalTo(priceLabel)
            make.top.equalTo(minPriceTextField.snp.bottom).offset(20)
        }

        saveFilterButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(56)
        }
    }
}
