import UIKit

final class BalanceViewController: BaseViewController {
    
    private var viewModel: BalanceViewModelProtocol!
    
    private let topUpBalanceTextField: BaseTextField = {
        let textField = BaseTextField()
        textField.placeholder = "₿"
        return textField
    }()
    
    private lazy var topUpBalanceButton: BaseButton = {
        let button = BaseButton()
        button.layer.cornerRadius = 10
        button.setTitle("Пополнить", for: .normal)
        button.addTarget(self, action: #selector(topUpBalanceButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let currentBalanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Текущий баланс:"
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        return label
    }()
    
    private let balanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ₿"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = BalanceViewModel()
        setupUI()
        getUpdatedBalance()
    }
    
    @objc
    private func topUpBalanceButtonDidTap() {
        guard let amount = topUpBalanceTextField.text else {
            return
        }
        
        guard viewModel.isValidAmount(amount: amount) else {
            let alert = UIAlertController(title: "Ошибка", message: "Сумма не может быть больше 300000", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        viewModel.topUpBalance(amount: amount) { [weak self] success in
            if success {
                self?.getUpdatedBalance()
            }
        }
    }

    
    private func getUpdatedBalance() {
        viewModel.getBalance { [weak self] balance in
            guard let balance = balance else { return }
            DispatchQueue.main.async {
                self?.balanceValueLabel.text = "\(balance) ₿"
            }
        }
    }
    
    private func setupUI() {
        title = "Balance"
        navigationItem.largeTitleDisplayMode = .never
        
        view.addSubview(topUpBalanceTextField)
        view.addSubview(topUpBalanceButton)
        view.addSubview(currentBalanceLabel)
        view.addSubview(balanceValueLabel)
        
        topUpBalanceTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(75)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            make.height.equalTo(36)
        }
        
        topUpBalanceButton.snp.makeConstraints { make in
            make.leading.equalTo(topUpBalanceTextField.snp.trailing).offset(16)
            make.width.equalTo(120)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.centerY.equalTo(topUpBalanceTextField.snp.centerY)
        }
        
        currentBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(topUpBalanceTextField.snp.bottom).offset(85)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
        }
        
        balanceValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(currentBalanceLabel.snp.trailing).offset(32)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(32)
            make.centerY.equalTo(currentBalanceLabel.snp.centerY)
        }
    }
}
