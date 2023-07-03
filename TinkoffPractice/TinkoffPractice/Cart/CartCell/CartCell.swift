import UIKit

final class CartCell: UITableViewCell {
    
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
    private var quantity = 1
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        quantityLabel.text = "\(quantity)"
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        minusButton.setImage(UIImage(systemName: "minus.square"), for: .normal)
        minusButton.addTarget(self, action: #selector(decreaseQuantity), for: .touchUpInside)
        
        plusButton.setImage(UIImage(systemName: "plus.square"), for: .normal)
        plusButton.addTarget(self, action: #selector(increaseQuantity), for: .touchUpInside)
        
        contentView.backgroundColor = .systemGray5
        
        contentView.addSubview(itemInCartImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)
        contentView.addSubview(minusButton)
        contentView.addSubview(plusButton)
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
    
    func configure(with item: Item) {
        itemInCartImageView.image = item.image
        titleLabel.text = item.name
        priceLabel.text = "\(item.price) ₿"
    }
    
    @objc func decreaseQuantity() {
        if quantity > 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
    }
    
    @objc func increaseQuantity() {
        quantity += 1
        quantityLabel.text = "\(quantity)"
    }
}
