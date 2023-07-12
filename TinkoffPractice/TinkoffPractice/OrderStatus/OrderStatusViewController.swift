import UIKit


final class OrderStatusViewController: BaseViewController {
    
    private var viewModel: OrderStatusViewModelProtocol!
            
    private var statusTitleLabel = makeLabel(text: "Статус", size: 20, color: .label, weight: .semibold)
    private var orderCreatedStausLabel = makeLabel(text: "\u{2022} Заказ создан", size: 22, color: .label, weight: .semibold)
    private var orderInDeliveryStausLabel = makeLabel(text: "\u{2022} Передано в доставку", size: 18, color: .systemGray, weight: .medium)
    private var orderRecievedStausLabel = makeLabel(text: "\u{2022} Заказ получен", size: 18, color: .systemGray, weight: .medium)
    private var orderCancelledStausLabel = makeLabel(text: "\u{2022} Заказ отменён", size: 22, color: .systemRed, weight: .semibold)
    
    private var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()
    
    private var productName = makeLabel(text: "", size: 17, color: .label, weight: .medium)
    private var productPrice = makeLabel(text: "", size: 16, color: .label, weight: .regular)
    private var productQuantity = makeLabel(text: "", size: 16, color: .label, weight: .regular)
    
    private var orderDateLabel = makeLabel(text: "Дата заказа ", size: 16, color: .label, weight: .medium)
    
    private lazy var changeDeliveryAddressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Изменить адрес доставки", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(changeDeliveryAddressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить заказ", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(cancelOrderButtonDidTap), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupProductDetails()
    }
    
    init(viewModel: OrderStatusViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func cancelOrderButtonDidTap() {
        let alert = UIAlertController(title: "Отмена заказа", message: "Вы уверены, что хотите отменить заказ?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            self?.viewModel.cancelOrder { success in
                if success {
                    DispatchQueue.main.async {
                        self?.orderCreatedStausLabel.textColor = .systemGray
                        self?.orderCreatedStausLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                        self?.orderCancelledStausLabel.isHidden = false
                    }
                }
            }
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }

    
    @objc
    private func changeDeliveryAddressButtonDidTap() {
        let changeDeliveryAddressVC = ChangeDeliveryAddressViewController()
        present(changeDeliveryAddressVC, animated: true)
    }
    
    private func setupProductDetails() {
        orderCancelledStausLabel.isHidden = true
        productImageView.image = viewModel.product.image
        productName.text = viewModel.product.name
        productPrice.text = String(viewModel.product.price)
        productQuantity.text = "x\(viewModel.product.quantity)"
        
        orderDateLabel.text = viewModel.getDateLabel()
    }
    
    
    
    private lazy var changeOrderStatusButton: UIButton = {
        let button = UIButton()
        button.setTitle("Обновить статус заказа", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(changeOrderStatusButtonDidTap), for: .touchUpInside)
        return button
    }()

    @objc
    private func changeOrderStatusButtonDidTap() {
        let nextStatus = viewModel.getNextStatus()

        switch nextStatus {
        case .created:
            break
        case .inDelivery:
            orderCreatedStausLabel.textColor = .systemGray
            orderCreatedStausLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            orderInDeliveryStausLabel.textColor = .label
            orderInDeliveryStausLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        case .received:
            orderInDeliveryStausLabel.textColor = .systemGray
            orderInDeliveryStausLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            orderRecievedStausLabel.textColor = .label
            orderRecievedStausLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        case .cancelled:
            break
        }
    }


    
    private func setupUI() {
        title = "Статус заказа"
        showUIViaRole()
        setupConstraints()
    }
    
    private func showUIViaRole() {
        viewModel.getUserRole { [weak self] userRole in
            DispatchQueue.main.async {
                if userRole == "Покупатель" {
                    // Показать кнопки для покупателя
                    self?.view.addSubview(self?.changeDeliveryAddressButton ?? UIView())
                    self?.view.addSubview(self?.cancelOrderButton ?? UIView())

                    self?.changeDeliveryAddressButton.snp.makeConstraints { make in
                        make.top.equalTo((self?.orderDateLabel.snp.bottom)!).offset(52)
                        make.leading.equalToSuperview().offset(16)
                    }

                    self?.cancelOrderButton.snp.makeConstraints { make in
                        make.top.equalTo((self?.changeDeliveryAddressButton.snp.bottom)!).offset(16)
                        make.leading.equalToSuperview().offset(16)
                    }
                    

                    

                } else if userRole == "Продавец" {
                    // Показать кнопку для продавца
                    self?.view.addSubview(self?.changeOrderStatusButton ?? UIView())

                    self?.changeOrderStatusButton.snp.makeConstraints { make in
                        make.top.equalTo((self?.orderDateLabel.snp.bottom)!).offset(52)
                        make.leading.equalToSuperview().offset(16)
                    }
                }
            }
        }
    }

    
    private static func makeLabel(text: String, size: Double, color: UIColor, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        return label
    }
    
    

    private func setupConstraints() {
        
        view.addSubview(statusTitleLabel)
        view.addSubview(orderCreatedStausLabel)
        view.addSubview(orderInDeliveryStausLabel)
        view.addSubview(orderRecievedStausLabel)
        view.addSubview(orderCancelledStausLabel)
        view.addSubview(orderDateLabel)
        view.addSubview(productName)
        view.addSubview(productImageView)
        view.addSubview(productPrice)
        view.addSubview(productQuantity)
        
        statusTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(112)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        orderCreatedStausLabel.snp.makeConstraints { make in
            make.top.equalTo(statusTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(52)
        }

        orderInDeliveryStausLabel.snp.makeConstraints { make in
            make.top.equalTo(orderCreatedStausLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(52)
        }

        orderRecievedStausLabel.snp.makeConstraints { make in
            make.top.equalTo(orderInDeliveryStausLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(52)
        }
        
        orderCancelledStausLabel.snp.makeConstraints { make in
            make.top.equalTo(orderRecievedStausLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(52)
        }
        
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(orderCancelledStausLabel.snp.bottom).offset(52)
            make.width.height.equalTo(90)
        }

        productName.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.top.equalTo(productImageView.snp.top).offset(24)
            make.trailing.lessThanOrEqualTo(productQuantity.snp.leading).offset(-10)
        }

        productPrice.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.top.equalTo(productName.snp.bottom)
            make.trailing.lessThanOrEqualTo(productQuantity.snp.leading).offset(-10)
        }

        productQuantity.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.centerY.equalTo(productImageView)
        }
                
        orderDateLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
        }

    }
    
}

