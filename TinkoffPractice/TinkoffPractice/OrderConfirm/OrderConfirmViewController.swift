import UIKit
import SnapKit

final class OrderConfirmViewController: BaseViewController {
    // MARK: - Properties

    private var viewModel: OrderConfirmViewModelProtocol!

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    private let deliveryAddressTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Enter delivery address"
        return textField
    }()


    private let deliveryTitleLabel: UILabel = makeLabel(text: "Доставка", size: 20, color: .label)
    private let totalPriceLabel: UILabel = makeLabel(text: "Сумма к оплате", size: 20, color: .label)
    private let deliveryPriceTitleLabel: UILabel = makeLabel(text: "Доставка", size: 16, color: .systemGray)
    private let deliveryPriceValueLabel: UILabel = makeLabel(text: "100 ₿", size: 16, color: .systemGray, alignment: .right)
    private let productsTitleLabel: UILabel = makeLabel(text: "Товары", size: 16, color: .systemGray)
    private let productsTotalPriceLabel: UILabel = makeLabel(text: "", size: 16, color: .systemGray, alignment: .right)
    private let totalSumTitleLabel: UILabel = makeLabel(text: "Итого", size: 18, color: .label)
    private let totalSumValueLabel: UILabel = makeLabel(text: "", size: 18, color: .label, alignment: .right)

    private lazy var paymentButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Оплатить", for: .normal)
        button.addTarget(self, action: #selector(paymentButtonDidTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Подтверждение заказа"
        navigationItem.largeTitleDisplayMode = .never
        bindViewModel()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.addSubview(tableView)
        setupTableFooterView()
        setupConstraints()
    }

    private static func makeLabel(text: String, size: CGFloat, color: UIColor, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        label.textColor = color
        label.text = text
        label.textAlignment = alignment
        return label
    }
    
    @objc
    private func paymentButtonDidTap() {
        let orderPaidVC = OrderHasBeenPaidViewController()
        navigationController?.pushViewController(orderPaidVC, animated: true)
    }

    private func setupTableFooterView() {
        let footerView = UIView()

        footerView.addSubview(deliveryTitleLabel)
        footerView.addSubview(totalPriceLabel)
        footerView.addSubview(deliveryAddressTextField)
        footerView.addSubview(deliveryPriceTitleLabel)
        footerView.addSubview(deliveryPriceValueLabel)
        footerView.addSubview(productsTitleLabel)
        footerView.addSubview(productsTotalPriceLabel)
        footerView.addSubview(totalSumTitleLabel)
        footerView.addSubview(totalSumValueLabel)
        footerView.addSubview(paymentButton)

        // Increase the height of the footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 400)

        tableView.tableFooterView = footerView
    }


    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        setupFooterConstraints()
    }

    private func setupFooterConstraints() {
        guard let footerView = tableView.tableFooterView else { return }

        deliveryTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalTo(footerView).offset(16)
        }

        deliveryAddressTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(deliveryTitleLabel.snp.bottom).offset(16)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(36)
        }

        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(deliveryAddressTextField.snp.bottom).offset(32)
            make.leading.equalTo(footerView).offset(16)
        }

        productsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(totalPriceLabel.snp.bottom).offset(16)
            make.leading.equalTo(footerView).offset(16)
        }

        productsTotalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(productsTitleLabel)
            make.trailing.equalTo(footerView).inset(16)
        }

        deliveryPriceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(productsTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(footerView).offset(16)
        }

        deliveryPriceValueLabel.snp.makeConstraints { make in
            make.top.equalTo(deliveryPriceTitleLabel)
            make.trailing.equalTo(footerView).inset(16)
        }

        totalSumTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(deliveryPriceTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(footerView).offset(16)
        }

        totalSumValueLabel.snp.makeConstraints { make in
            make.top.equalTo(totalSumTitleLabel)
            make.trailing.equalTo(footerView).inset(16)
        }

        paymentButton.snp.makeConstraints { make in
            make.centerX.equalTo(footerView.snp.centerX)
            make.bottom.equalTo(footerView.snp.bottom).inset(16)
            make.width.equalTo(footerView.snp.width).multipliedBy(0.9)
            make.height.equalTo(56)
        }
    }

    private func bindViewModel() {
        viewModel = OrderConfirmViewModel()
        
        let totalSum = viewModel.totalSum() + 100
        totalSumValueLabel.text = String(format: "%.2f ₿", totalSum + 100)
        productsTotalPriceLabel.text = String(format: "%.2f ₿", totalSum)
    }

}

// MARK: - UITableViewDelegate

extension OrderConfirmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
}

// MARK: - UITableViewDataSource

extension OrderConfirmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell",
            for: indexPath
        ) as? OrderItemCell else {
            assertionFailure("Failed to dequeue OrderItemCell")
            return UITableViewCell()
        }

        let item = viewModel.item(at: indexPath.row)
        let itemViewModel = OrderItemViewModel(product: item)
        cell.configure(with: itemViewModel)
        return cell
    }

}
