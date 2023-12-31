import UIKit

final class CartCell: UITableViewCell {
    
    var product: Product?

    private let itemInCartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()

    private var titleLabel = UILabel()
    private var priceLabel = UILabel()
    private var quantityLabel = UILabel()
    private var minusButton = UIButton()
    private var plusButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.numberOfLines = 2

        minusButton.setImage(UIImage(systemName: "minus.square"), for: .normal)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)

        plusButton.setImage(UIImage(systemName: "plus.square"), for: .normal)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)

        contentView.backgroundColor = .systemBackground

        contentView.addSubview(itemInCartImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
        contentView.addSubview(quantityLabel)
    }
    
    var viewModel: CartCellViewModelProtocol? {
        didSet {
            titleLabel.text = viewModel?.product.name
            priceLabel.text = "\(viewModel?.product.price ?? 0.0) ₿"
            quantityLabel.text = "\(viewModel?.product.quantity ?? 1)"
            viewModel?.quantityDidChange = { [weak self] quantity in
                DispatchQueue.main.async {
                    self?.quantityLabel.text = "\(quantity)"
                }
            }
        }
    }

    func setupConstraints() {
        itemInCartImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(90)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemInCartImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(itemInCartImageView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(-30) // уменьшен отступ сверху
            make.bottom.equalToSuperview()
        }

        minusButton.snp.makeConstraints { make in
            make.trailing.equalTo(quantityLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

        quantityLabel.snp.makeConstraints { make in
            make.trailing.equalTo(plusButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

        plusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }
    }




    func configure(with product: Product) {
        self.product = product
        itemInCartImageView.image = product.image
        titleLabel.text = product.name
        priceLabel.text = "\(product.price) ₿"
        quantityLabel.text = "\(product.quantity)"
    }


    @objc func decreaseQuantity() {
        if product?.quantity ?? 0 > 1 {
            product?.quantity -= 1
            quantityLabel.text = "\(product?.quantity ?? 0)"
        }
    }

    @objc func increaseQuantity() {
        product?.quantity += 1
        quantityLabel.text = "\(product?.quantity ?? 0)"
    }

}
