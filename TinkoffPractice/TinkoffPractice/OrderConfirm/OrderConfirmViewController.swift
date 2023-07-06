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
        tableView.backgroundColor = .white
        return tableView
    }()

    private let userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        return label
    }()

    private let userPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "User Phone"
        return label
    }()

    private let deliveryAddressTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Enter delivery address"
        return textField
    }()

    private let deliveryFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "Доставка: 100"
        return label
    }()

    private let totalSumLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого: "
        return label
    }()

    private lazy var paymentButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Оплатить", for: .normal)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Подтверждение заказа"
        navigationController?.navigationBar.prefersLargeTitles = false
        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(userIcon)
        view.addSubview(userNameLabel)
        view.addSubview(userPhoneLabel)
        view.addSubview(deliveryAddressTextField)
        view.addSubview(deliveryFeeLabel)
        view.addSubview(totalSumLabel)
        view.addSubview(paymentButton)
        setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        userIcon.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }

        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userIcon.snp.top)
            make.leading.equalTo(userIcon.snp.trailing).offset(16)
        }

        userPhoneLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(4)
            make.leading.equalTo(userIcon.snp.trailing).offset(16)
        }

        deliveryAddressTextField.snp.makeConstraints { make in
            make.top.equalTo(userIcon.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        deliveryFeeLabel.snp.makeConstraints { make in
            make.top.equalTo(deliveryAddressTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        totalSumLabel.snp.makeConstraints { make in
            make.top.equalTo(deliveryFeeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        paymentButton.snp.makeConstraints { make in
            make.top.equalTo(totalSumLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    private func bindViewModel() {
        viewModel = OrderConfirmViewModel()
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "OrderItemCell",
            for: indexPath
        ) as? OrderItemCell else {
            assertionFailure("Failed to dequeue OrderItemCell")
            return UITableViewCell()
        }

        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)
        return cell
    }
}
