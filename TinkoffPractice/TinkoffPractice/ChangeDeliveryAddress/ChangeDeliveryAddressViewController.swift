import UIKit
import SnapKit


final class ChangeDeliveryAddressViewController: BaseViewController {
    
    private var viewModel: ChangeDeliveryAddressViewModelProtocol!
    
    private let newDeliveryAddressTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "Новый адрес доставки"
        return textField
    }()
    
    private lazy var changeDeliveryAddressButton: BaseButton = {
        let button = BaseButton()
        button.setTitle("Изменить адрес", for: .normal)
        button.addTarget(self, action: #selector(changeDeliveryAddressButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChangeDeliveryAddressViewModel()
        setupUI()
    }
    
    @objc
    private func changeDeliveryAddressButtonDidTap() {
        guard let newAddress = newDeliveryAddressTextField.text else { return }
        viewModel.changeDeliveryAddress(newAddress: newAddress) { [weak self] success in
            if success {
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(newDeliveryAddressTextField)
        view.addSubview(changeDeliveryAddressButton)
        
        newDeliveryAddressTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(130)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(36)
        }
        
        changeDeliveryAddressButton.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(newDeliveryAddressTextField.snp.bottom).offset(30)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(56)
        }
    }
    
}
