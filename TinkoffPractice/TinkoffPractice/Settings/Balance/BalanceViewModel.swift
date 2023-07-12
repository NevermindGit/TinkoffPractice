protocol BalanceViewModelProtocol: AnyObject {
    func getBalance(completion: @escaping ((Double?) -> Void))
    func topUpBalance(amount: String, completion: @escaping (Bool) -> Void)
    func isValidAmount(amount: String) -> Bool
}

class BalanceViewModel: BalanceViewModelProtocol {

    private var dataManager: DataManagerProtocol
    
    private let maxAmount = 300000.0

    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }

    func getBalance(completion: @escaping ((Double?) -> Void)) {
        dataManager.getBalance { balance in
            completion(balance)
        }
    }

    func topUpBalance(amount: String, completion: @escaping (Bool) -> Void) {
        dataManager.topUpBalance(amount: amount, completion: completion)
    }
    
    func isValidAmount(amount: String) -> Bool {
        if let value = Double(amount), value > maxAmount {
            return false
        }
        return true
    }
}
