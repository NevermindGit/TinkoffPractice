import UIKit
import SnapKit

class AboutAppViewController: BaseViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let appDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let developerInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "О приложении"
        navigationItem.largeTitleDisplayMode = .never
        setupViews()
        setupConstraints()
        populateData()
    }
    
    private func setupViews() {
        view.addSubview(logoImageView)
        view.addSubview(appNameLabel)
        view.addSubview(appVersionLabel)
        view.addSubview(appDescriptionLabel)
        view.addSubview(developerInfoLabel)
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.height.equalTo(100)
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        appVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(appNameLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        appDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(appVersionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        developerInfoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func populateData() {
        logoImageView.image = UIImage(systemName: "terminal")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        appNameLabel.text = "TMarket"
        appVersionLabel.text =  "1.1.0"
        appDescriptionLabel.text = "Это приложение является маркетплейсом, обеспечивающим взаимодействие между покупателями и продавцами. Оно предоставляет уникальную возможность для покупателей составлять заказы, включающие разнообразные товары от различных продавцов. \nПосле оформления заказа, продавец обязан отправить товар и обновить статус заказа в системе. При запуске приложения, пользователь встречается с экраном авторизации. Если у пользователя нет учетной записи, он может без труда зарегистрироваться. В процессе использования приложения, пользователь имеет возможность пополнять свой внутренний кошелек, что позволяет совершать покупки прямо в приложении."
        developerInfoLabel.text = "iOS Lab"
    }
}
