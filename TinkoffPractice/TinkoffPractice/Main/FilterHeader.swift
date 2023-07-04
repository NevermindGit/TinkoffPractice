import UIKit


protocol FilterHeaderDelegate: AnyObject {
    func filterButtonDidTap()
}


final class FilterHeader: UICollectionReusableView {
    
    weak var delegate: FilterHeaderDelegate?
    
    private lazy var filterButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Фильтры", for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(filterButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @objc
    private func filterButtonDidTap() {
        delegate?.filterButtonDidTap()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(filterButton)
        
        filterButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(105)
            make.height.equalTo(30)
        }
    }
}
