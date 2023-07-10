import UIKit


final class MyOrdersViewController: BaseViewController {
    
    // MARK: - Properties
    private var viewModel: MyOrdersViewModelProtocol! {
        didSet {
            viewModel.getMyProducts { [weak self] result in
                switch result {
                case .success:
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error)")
                }
                self?.tableView.reloadData()
            }
        }
    }
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MyOrdersCell.self, forCellReuseIdentifier: "MyOrdersCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel = MyOrdersViewModel()
    }
    
    private func configureUI() {
        navigationItem.title = "Мои заказы"
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(tableView)

        setupConstraints()
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.backgroundColor = .systemBackground
    }
    
}

// MARK: - UITableViewDelegate

extension MyOrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let orderStatusViewModel = viewModel.getOrdersStatusViewModel(at: indexPath)
        let ordersStatusVC = OrderStatusViewController(viewModel: orderStatusViewModel)
        present(ordersStatusVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MyOrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfProducts()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersCell", for: indexPath)
        guard let cell = cell as? MyOrdersCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getMyOrdersCellViewModel(at: indexPath)
        return cell
    }

}
