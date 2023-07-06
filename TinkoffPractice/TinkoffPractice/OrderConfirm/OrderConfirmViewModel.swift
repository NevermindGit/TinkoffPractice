import Foundation

protocol OrderConfirmViewModelProtocol {
    var numberOfItems: Int { get }
    func item(at index: Int) -> Item
}

final class OrderConfirmViewModel: OrderConfirmViewModelProtocol {

    var numberOfItems: Int {
        CartManager.shared.getItems().count
    }

    func item(at index: Int) -> Item {
        CartManager.shared.getItems()[index]
    }
}
