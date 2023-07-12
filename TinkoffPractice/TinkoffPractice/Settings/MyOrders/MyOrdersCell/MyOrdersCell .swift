import UIKit


final class MyOrdersCell: UITableViewCell {

    private let productImageView: UIImageView = {
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

        contentView.backgroundColor = .systemBackground

        contentView.addSubview(productImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(quantityLabel)

    }
    
    var viewModel: MyOrdersCellViewModelProtocol? {
        didSet {
            productImageView.image = viewModel?.itemImage
            titleLabel.text = viewModel?.itemName
            priceLabel.text = viewModel?.itemPrice
            quantityLabel.text = viewModel?.itemQuantity
        }
    }

    func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(90)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview().offset(-10)
            make.trailing.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(-30) // уменьшен отступ сверху
            make.bottom.equalToSuperview()
        }
        
        quantityLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(32)
            make.centerY.equalToSuperview()
        }
    }

}
