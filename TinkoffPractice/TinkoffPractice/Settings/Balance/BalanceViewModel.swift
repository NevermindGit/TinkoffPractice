protocol BalanceViewModelProtocol: AnyObject {
    func getBalance(completion: @escaping ((Double) -> Void))
    func topUpBalance(amount: String, completion: @escaping ((Bool) -> Void))
}

class BalanceViewModel: BalanceViewModelProtocol {

    private var dataManager: DataManagerProtocol

    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }

    func getBalance(completion: @escaping ((Double) -> Void)) {
        dataManager.getBalance(completion: completion)
    }

    func topUpBalance(amount: String, completion: @escaping ((Bool) -> Void)) {
        dataManager.topUpBalance(amount: amount, completion: completion)
    }
}
