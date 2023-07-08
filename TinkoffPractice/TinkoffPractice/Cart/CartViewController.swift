import UIKit
import SnapKit

final class CartViewController: BaseViewController {
    // MARK: - Properties
    private var viewModel: CartViewModelProtocol!
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        return tableView
    }()
    private lazy var createOrderButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Оформить заказ", for: .normal)
        button.addTarget(self, action: #selector(createOrderButtonDidTap), for: .touchUpInside)
        return button
    }()
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        updateOrderButtonState()
    }
    // MARK: - Private Methods

    @objc
    private func createOrderButtonDidTap() {
        let orderConfirmVC = OrderConfirmViewController()
        navigationController?.pushViewController(orderConfirmVC, animated: true)
    }

    private func bindViewModel() {
        viewModel = CartViewModel()

        viewModel.productAdded = { [weak self] in
            self?.tableView.reloadData()
            self?.updateOrderButtonState()
        }
    }

    private func updateOrderButtonState() {
        let itemCount = viewModel.numberOfProducts
        createOrderButton.isEnabled = itemCount > 0
        createOrderButton.backgroundColor = itemCount > 0 ? UIColor.systemYellow : UIColor.systemGray4
    }

    private func configureUI() {
        navigationItem.title = "Cart"
        navigationItem.largeTitleDisplayMode = .always

        view.addSubview(tableView)
        view.addSubview(createOrderButton)

        setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.left.equalTo(view.snp.left)
//            make.right.equalTo(view.snp.right)
//            make.bottom.equalTo(createOrderButton.snp.top).offset(-16)
        }

        createOrderButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(56)
        }
        
        tableView.backgroundColor = .systemBackground
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDataSource
extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell
        let item = viewModel.product(at: indexPath.row)
        cell?.configure(with: item)
        return cell!
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.removeProduct(at: indexPath.row)
            tableView.endUpdates()
            updateOrderButtonState()
        }
    }
}
