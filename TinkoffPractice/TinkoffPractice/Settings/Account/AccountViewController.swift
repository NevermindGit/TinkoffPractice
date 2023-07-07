import UIKit


final class AccountViewController: BaseViewController {
    
    private let accountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(systemName: "person.circle")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private let usersRole: UILabel = {
        let label = UILabel()
        label.text = DataManager.shared.getUserRole()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Аккант"
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(accountImageView)
        view.addSubview(usersRole)
        
        accountImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.height.equalTo(125)
        }
        
        usersRole.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(accountImageView.snp.bottom).offset(16)
        }
    }
    
}
