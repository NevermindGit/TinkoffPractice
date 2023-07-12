import UIKit
import SnapKit

final class OrderItemCell: UITableViewCell {
    private let itemInCartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var titleLabel = UILabel()
    private var priceLabel = UILabel()
    private var quantityLabel = UILabel()
    private var quantity = 1

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        titleLabel.numberOfLines = 2

        contentView.backgroundColor = .systemBackground

        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(itemInCartImageView)
        contentView.addSubview(quantityLabel)
    }

    private func setupConstraints() {
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
            make.top.equalTo(titleLabel.snp.bottom).inset(30)
            make.bottom.equalToSuperview()
        }

        quantityLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide.snp.trailing).inset(30)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: OrderItemViewModelProtocol) {
        itemInCartImageView.image = viewModel.productImage
        titleLabel.text = viewModel.productName
        priceLabel.text = String(format: "%.2f", viewModel.productPrice)
        quantityLabel.text = "x\(viewModel.productQuantity)"
    }


}
