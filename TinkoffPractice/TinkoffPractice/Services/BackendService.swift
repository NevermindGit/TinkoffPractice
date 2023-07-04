import Foundation
import Alamofire

protocol BackendServiceProtocol: AnyObject {
    func sendRequest(endpoint: String, method: HTTPMethod, parameters: Parameters?, completion: @escaping (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void)
}


final class BackendService: BackendServiceProtocol {
    
    static let shared = BackendService()
    
    private init() {}
        
    func sendRequest(endpoint: String, method: HTTPMethod, parameters: Parameters? = nil, completion: @escaping (_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) -> Void) {
        guard let url = URL(string: endpoint) else {
            print("Invalid endpoint: \(endpoint)")
            return
        }
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default).validate().response { (response) in
            switch response.result {
            case .success(let data):
                completion(data, response.response, nil)
            case .failure(let error):
                print("Ошибка при отправке данных: \(error)")
                completion(nil, response.response, error)
            }
        }
    }
}
