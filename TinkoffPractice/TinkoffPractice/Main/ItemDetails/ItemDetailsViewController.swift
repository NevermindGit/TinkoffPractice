import UIKit


class ItemDetailsViewController: BaseViewController {
    
    private let itemTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 3
        return label
    }()
    
    private let itemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 10
        return label
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private lazy var addToCartButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("В корзину", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(addToCartButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: "placeholder")
        return imageView
    }()

    
    var viewModel: ItemDetailsViewModelProtocol! {
        didSet {
            viewModel.itemDidChange = { [weak self] in
                self?.updateNewsLabels()
            }
        }
    }
    
    init(viewModel: ItemDetailsViewModelProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateNewsLabels()
        
        viewModel.itemDidChange = { [weak self] in
            self?.updateNewsLabels()
        }
    }
    
    @objc
    private func addToCartButtonDidTap() {
        viewModel.addToCart()
    }
    
    private func setupUI() {
        view.addSubview(itemImageView)
        view.addSubview(itemTitleLabel)
        view.addSubview(itemDescriptionLabel)
        view.addSubview(itemPriceLabel)
        view.addSubview(addToCartButton)
        
        itemImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(393)
        }
        
        itemTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        itemDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(itemTitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
        }
        
        itemPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(addToCartButton.snp.centerY)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.width.equalTo(139)
            make.height.equalTo(37)
        }
    }


    
    private func updateNewsLabels() {
        itemTitleLabel.text = viewModel.itemName
        itemDescriptionLabel.text = viewModel.itemDescription
        itemImageView.image = viewModel.itemImage
        itemPriceLabel.text = "\(viewModel.itemPrice) ₿"
        itemImageView.setNeedsLayout()
        itemImageView.layoutIfNeeded()
    }
    
}
