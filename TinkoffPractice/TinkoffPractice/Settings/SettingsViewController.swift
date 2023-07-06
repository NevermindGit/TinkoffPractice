import UIKit
import SnapKit

class SettingsViewController: BaseViewController {
        
    private lazy var exitButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(exitButtonDidTap), for: .touchUpInside)
        return button
    }()

    @objc
    private func exitButtonDidTap() {
        
        UserCredentials.deleteFromCoreData()
        
        let navLoginVC = UINavigationController(rootViewController: LoginViewController(dataManager: DataManager.shared))
        navLoginVC.modalPresentationStyle = .fullScreen
        present(navLoginVC, animated: true)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.addSubview(exitButton)
        
        exitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width * 0.9)
            make.height.equalTo(view.frame.height * 0.07)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}
