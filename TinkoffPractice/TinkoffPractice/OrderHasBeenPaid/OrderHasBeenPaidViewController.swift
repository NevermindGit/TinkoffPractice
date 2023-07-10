import UIKit


final class OrderHasBeenPaidViewController: BaseViewController {
    
    private var viewModel: OrderHasBeenPaidViewModelProtocol!
    
    private let orderSuccessImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "checkmark.circle")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private let orderHasBeenPaidLabel: UILabel = {
        let label = UILabel()
        label.text = "Заказ успешно оплачен!"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(OrderItemCell.self, forCellReuseIdentifier: "OrderItemCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    private let orderDateLabel: UILabel = {
        let label = UILabel()

        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    
    private lazy var backToMainScreenButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("На главную", for: .normal)
        button.addTarget(self, action: #selector(backToMainScreenButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
    }
    
    @objc
    private func backToMainScreenButtonDidTap() {
        tabBarController?.selectedIndex = 0
        if let navigationController = self.navigationController {
            var navigationArray = navigationController.viewControllers
            navigationArray.removeLast()
            navigationArray.removeLast()
            navigationController.viewControllers = navigationArray
        }
    }
    
    private func setupUI() {
        title = "Статус заказа"
        navigationItem.hidesBackButton = true
        view.addSubview(tableView)
        setupTableFooterView()
        setupTableHeaderView()
        setupConstraints()
    }
    
    private func bindViewModel() {
        viewModel = OrderHasBeenPaidViewModel()
        orderDateLabel.text = viewModel.getDateLabel()
    }
    
    private func setupTableFooterView() {
        let footerView = UIView()
        
        footerView.addSubview(orderDateLabel)
        footerView.addSubview(backToMainScreenButton)
        
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150)

        tableView.tableFooterView = footerView
    }
    
    private func setupTableHeaderView() {
        let headerView = UIView()
        
        headerView.addSubview(orderSuccessImage)
        headerView.addSubview(orderHasBeenPaidLabel)

        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 275)

        tableView.tableHeaderView = headerView
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
                
        guard let headerView = tableView.tableHeaderView else { return }
        
        orderSuccessImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(headerView.snp.top).offset(50)
            make.width.height.equalTo(150)
        }
        
        orderHasBeenPaidLabel.snp.makeConstraints { make in
            make.top.equalTo(orderSuccessImage.snp.bottom)
            make.centerX.equalToSuperview()
        }

        
        guard let footerView = tableView.tableFooterView else { return }
        
        orderDateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(16)
        }

        backToMainScreenButton.snp.makeConstraints { make in
            make.top.equalTo(orderDateLabel.snp.bottom).offset(32)
            make.centerX.equalTo(footerView.snp.centerX)
            make.width.equalTo(footerView.snp.width).multipliedBy(0.9)
            make.height.equalTo(56)
        }

    }
}

// MARK: - UITableViewDelegate

extension OrderHasBeenPaidViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProduct = viewModel.item(at: indexPath.row)
        let orderStatusVM = OrderStatusViewModel(product: selectedProduct)
        let orderStatusVC = OrderStatusViewController(viewModel: orderStatusVM)
        
        present(orderStatusVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension OrderHasBeenPaidViewController: UITableViewDataSource {
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
        let itemViewModel = OrderItemViewModel(cartProduct: item)
        cell.configure(with: itemViewModel)
        return cell
    }

}
