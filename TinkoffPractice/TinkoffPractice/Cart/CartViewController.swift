import UIKit


final class CartViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    private var viewModel: CartViewModelProtocol!
    
    private lazy var createOrderButton: BaseButton = {
        let button = BaseButton(type: .roundedRect)
        button.setTitle("Оформить заказ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(createOrderButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func createOrderButtonDidTap() {
        viewModel.createOrder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Cart"
        navigationController?.navigationBar.prefersLargeTitles = true

        
        viewModel = CartViewModel()
   
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(CartCell.self, forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(createOrderButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        createOrderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: createOrderButton.topAnchor, constant: -16),
            
            createOrderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createOrderButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            createOrderButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        
        viewModel.itemAdded = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        let item = viewModel.item(at: indexPath.row)
        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            viewModel.removeItem(at: indexPath.row)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }

}
