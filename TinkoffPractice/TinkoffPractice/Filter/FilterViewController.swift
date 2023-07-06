import UIKit
import SnapKit

final class FilterViewController: UIViewController {

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
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
        label.textColor = UIColor.black
        label.text = "Категории"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var saveFilterButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return button
    }()

    private let categories: [String] = [
        "Категория 1", "Категория 2", "Категория 3",
        "Категория 4", "Категория 5", "Категория 6",
        "Категория 7", "Категория 8", "Категория 9",
        "какая то длинная категория", "Категория 9"
    ]

    private var categoryButtons: [UIButton] = []

    private var selectedCategories: [String] = []

    private let buttonHeight: CGFloat = 30
    private let buttonSpacing: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(priceLabel)
        view.addSubview(minPriceTextField)
        view.addSubview(maxPriceTextField)
        view.addSubview(categoriesLabel)
        view.addSubview(saveFilterButton)

        setupCategoryButtons()
        setupConstraints()
    }

    private func setupCategoryButtons() {
        var buttonOrigin = CGPoint(x: buttonSpacing, y: 170)

        for category in categories {
            let button = BaseButton()
            button.setTitle(category, for: .normal)
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.06)
        }
    }

    @objc
    private func buttonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.backgroundColor = sender.isSelected ? .systemYellow : .systemGray5

        guard let title = sender.currentTitle else { return }

        if sender.isSelected {
            selectedCategories.append(title)
        } else {
            if let index = selectedCategories.firstIndex(of: title) {
                selectedCategories.remove(at: index)
            }
        }

        print(selectedCategories)
    }
}
