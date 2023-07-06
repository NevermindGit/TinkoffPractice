import UIKit


final class AccountViewController: BaseViewController {
    
    private var accountImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(systemName: "person.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        return imageView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account"
        
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(accountImageView)
        
        accountImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.width.height.equalTo(125)
        }
    }
    
}
