protocol ChangeDeliveryAddressViewModelProtocol: AnyObject {
    func changeDeliveryAddress(newAddress: String, completion: @escaping ((Bool) -> Void))
}

final class ChangeDeliveryAddressViewModel: ChangeDeliveryAddressViewModelProtocol {
    
    func changeDeliveryAddress(newAddress: String, completion: @escaping ((Bool) -> Void)) {
        completion(true)
    }

}
