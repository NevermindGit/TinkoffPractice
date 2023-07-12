import Foundation
import UIKit
import Alamofire

protocol DataManagerProtocol: AnyObject {
    func addUserToDatabase(login: String, username: String, password: String, userType: String, completion: @escaping(Bool) -> Void)
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool, String, String) -> Void)
    func fetchAllItems(completion: @escaping (([Product]) -> Void))
    func fetchItemsWithFilter(minPrice: Double, maxPrice: Double, сategories: [String], sellersId: [Int], completion: @escaping (([Product]) -> Void))
    func topUpBalance(amount: String, completion: @escaping (Bool) -> Void)
    func getBalance(completion: @escaping (Double?) -> Void)
    func fetchBuyersOrders(completion: @escaping ([Order]) -> Void)
    func fetchSellersOrders(completion: @escaping ([Order]) -> Void)
    func editProduct(image: UIImage, name: String, description: String,
                     price: String, category: String, completion: @escaping (Bool) -> Void)
}

final class DataManager: DataManagerProtocol {
    public static let shared = DataManager()
    private init() {
        headers = [
            "X-Request-Id": "1",
            "Content-type": "application/json"
        ]
    }
    
    private let host = "http://192.168.1.55:5001/"
    
    private let accessToken = String(describing: UserCredentials.loadFromCoreData()?.accessToken)
    
    private let headers: HTTPHeaders

    func addUserToDatabase(login: String, username: String, password: String, userType: String, completion: @escaping(Bool) -> Void) {
        print("User \(username) - \(login) with role \(userType) was added to DB")

        let parameters: Parameters = ["username": username, "login": login, "password": password, "userType": userType]
        print(headers)
        print(parameters)
        BackendService.shared.sendRequest(endpoint: "\(host)create_user", method: .post, parameters: parameters, headers: headers) { data, response, error in
            print(data)
            print(response, response?.statusCode)
            if let error = error {
                print("Произошла ошибка: \(error)")
            } else if let response = response {
                switch response.statusCode {
                case 200:
                    print("Пользователь успешно добавлен")
                    completion(true)
                default:
                    print("Неожиданный код ответа: \(response.statusCode)")
                    completion(false)
                }
            }
        }
    }

    
    func checkIfUserExists(login: String, password: String, completion: @escaping (Bool, String, String) -> Void) {
        let parameters: Parameters = ["username": login, "password": password]
        
        BackendService.shared.sendRequest(endpoint: "\(host)/login", method: .post, parameters: parameters, headers: headers) { data, response, error in
            if let error = error {
                print("Произошла ошибка: \(error)")
                completion(false, "", "")
            } else if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                        let token = json["access_token"] ?? ""
                        print(token)
                        let role = json["role"] ?? ""
                        DispatchQueue.main.async {
                            completion(true, token, role)
                        }
                    }
                } catch {
                    print("Ошибка при декодировании данных: \(error)")
                    completion(false, "", "")
                }
            }
        }
    }


    func fetchAllItems(completion: @escaping (([Product]) -> Void)) {
        let item1 = Product(
            id: 1, name: "Apple AirPods Pro 2", price: 22669.0,
            image: UIImage(named: "AirPods") ?? UIImage(),
            description: "AirPods Pro были переработаны для еще более насыщенного воспроизведения звука. Активное шумоподавление следующего уровня и адаптивная прозрачность снижают уровень внешних шумов. Пространственный звук выводит погружение на удивительно личный уровень. Сенсорное управление теперь позволяет регулировать громкость одним движением. А скачок в мощности обеспечивает 6 часов автономной работы от одного заряда.", category: "1", quantity: 1
        )
        let item2 = Product(
            id: 2, name: "Умная колонка Яндекс Станция Мини", price: 6999.0,
            image: UIImage(named: "alisa") ?? UIImage(),
            description: "Яндекс.Станция Мини - обновленная версия умной колонки с голосовым ассистентом Алиса. Данная модель получила более громкий звук мощностью 10 Вт. Колонка управляется не только голосом, но и с помощью сенсорных кнопок, расположенных сверху. Алиса по-прежнему умеет управлять 'Умным домом', подбирать музыку, знает много детских сказок, разбудит вовремя, расскажет новости или напомнит о важных делах. Станции Мини впишется в большинство интерьеров благодаря лаконичному дизайну и различным цветам. Подключается колонка к интернету по Wi-Fi, а Bluetooth 5.0 позволит подключать такие устройства, как умную лампу, пылесос и сотни других устройств.", category: "1", quantity: 1
        )
        let item6 = Product(
            id: 3, name: "Японские наручные часы Casio A-158WA-1D", price: 3033.0,
            image: UIImage(named: "casio") ?? UIImage(),
            description: "Браслет из нержавеющей стали Особенностями стального браслета всегда были его вес (они тяжелее остальных, кому-то это очень нравится) и долговечность (если на часах нет покрытий, т. к. любое покрытие - это краска, которая не восстанавливается при ее утрате в процессе эксплуатации. Браслет без покрытий можно легко полировать и давать своим часам вторую жизнь). Еще из особенностей - часы со стальным браслетом относительно долго нагреваются до температуры тела. Кому-то это нравится, кому-то нет, зависит индивидуально от каждого", category: "1", quantity: 1
        )
        let item4 = Product(
            id: 4, name: "Микрофон проводной HyperX QuadCast", price: 10290.0,
            image: UIImage(named: "Mic") ?? UIImage(),
            description: "HyperX QuadCast — полнофункциональный автономный микрофон, который идеально подходит для начинающих стримеров или подкастеров, которым необходим конденсаторный микрофон с высоким качеством звука. Микрофон QuadCast оснащен собственным амортизирующим подвесом, который помогает снизить шум окружающей среды, и встроенным поп-фильтром, с помощью которого можно приглушить надоедливые взрывные звуки. Проверьте состояние своего микрофона с помощью светодиодного индикатора или отключите звук во избежание возможных проблем во время трансляций. Благодаря четырем полярным диаграммам направленности этот микрофон подготовлен практически к любой ситуации записи, а также имеет удобно расположенный шкалу регулировки усиления для быстрой настройки чувствительности входа микрофона.", category: "1", quantity: 1
        )
        let item5 = Product(
            id: 5, name: "Сноуборд Arbor Crosscut Rocker", price: 43200.0,
            image: UIImage(named: "snow") ?? UIImage(),
            description: "Модель Crosscut отличается направленной геометрией, легкой конусностью и задним размещением креплений, что обеспечивает комфорт на грумере и легкость движения по рыхлому снегу. Боковой вырез большего радиуса упрощает карвинг на высоких скоростях и улучшает управляемость на крутых спусках. Особенности: Hand Dyed Ash Powerply Пауерплай из ясеня, уложенный вручную Bio-Plastic Topsheet За счет материала изготовленного на основе из касторового масла, получается экологичный, очень прочный и водоотталкивающий топшит.", category: "1", quantity: 1
        )
        let item3 = Product(
            id: 6, name: "Nike Blazer Mid '77", price: 12399.0,
            image: UIImage(named: "blazer") ?? UIImage(),
            description: "Мужские кроссовки Nike Blazer Mid '77 являются классическим образцом баскетбольной обуви с культовым дизайном, разработанным Питером Муром 37 лет назад. Пара получила верх из натуральной кожи и традиционную комбинацию панелей в стиле колор-блок из сдержанных и спокойных цветов.", category: "1", quantity: 1
        )
        
        let item7 = Product(
            id: 5, name: "Nike Air Max 95", price: 12990.0,
            image: UIImage(named: "95") ?? UIImage(),
            description: "Blabla", category: "1", quantity: 1
        )

        print("Fetch items from DB")
        completion([item1, item2, item3, item4, item5, item6, item7])
    }

    func fetchItemsWithFilter(minPrice: Double, maxPrice: Double, сategories: [String], sellersId: [Int], completion: @escaping (([Product]) -> Void)) {
        BackendService.shared.sendRequest(endpoint: "\(host)/products?minPrice=\(minPrice)&maxPrice=\(maxPrice)&categories=\(сategories)&sellers=\(sellersId)", method: .get) { data, response, error in
            let product = Product(id: 120, name: "Product From Seller", price: 17999, image: UIImage(named: "nike")!, description: "ajsdjasd", category: "some", quantity: 1)
            completion([product])
        }
    }
    
    func getUserRole() -> String {
        UserCredentials.loadFromCoreData()?.userRole ?? "none"
    }
    
    func addToCart(productId: Int, completion: @escaping(String?) -> Void) {
        BackendService.shared.sendRequest(endpoint: "\(host)/addToCart/\(productId)", method: .put, headers: headers) { data, response, error in
            if error == nil, let data = data {
                do {
                    let json = try JSONDecoder().decode([String: String].self, from: data)
                    let quantity = json["quantity"]
                    if quantity != nil {
                        completion(quantity)
                    }
                } catch {
                    print("Error decoding response: \(error)")
                    completion(nil)
                }
            } else {
                print("Error topping up balance: \(error?.localizedDescription ?? "No data")")
                completion(nil)
            }
        }
    }
    
    func removeFromCart(productId: Int, completion: @escaping(String?) -> Void) {
        BackendService.shared.sendRequest(endpoint: "\(host)/removeFromCart/\(productId)", method: .put, headers: headers) { data, response, error in
            if error == nil, let data = data {
                do {
                    let json = try JSONDecoder().decode([String: String].self, from: data)
                    let quantity = json["quantity"]
                    if quantity != nil {
                        completion(quantity)
                    }
                } catch {
                    print("Error decoding response: \(error)")
                    completion(nil)
                }
            } else {
                print("Error topping up balance: \(error?.localizedDescription ?? "No data")")
                completion(nil)
            }
        }
    }
    
    func removeAllFromCart(productId: Int, completion: @escaping (Bool) -> Void) {
        BackendService.shared.sendRequest(endpoint: "\(host)/removeAllFromCart\(productId)", method: .put, headers: headers) { data, response, error in
            if error == nil, let data = data {
                do {
                    let json = try JSONDecoder().decode([String: String].self, from: data)
                    if json["status"] == "success" {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    print("Error decoding response: \(error)")
                    completion(false)
                }
            } else {
                print("Error topping up balance: \(error?.localizedDescription ?? "No data")")
                completion(false)
            }
        }
    }
    
    func createProduct(image: UIImage, name: String, description: String,
                       price: String, completion: @escaping (Bool) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(false)
            return
        }

        // Convert the image to a Base64 string
        let base64Image = imageData.base64EncodedString()

        let parameters: [String: Any] = [
            "name": name,
            "description": description,
            "price": price,
            "photo": base64Image
        ]

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(String(describing: UserCredentials.loadFromCoreData()?.accessToken))",
            "Content-type": "application/json"
        ]

        BackendService.shared.sendRequest(endpoint: "\(host)/create_product",
                                          method: .post, parameters: parameters, headers: headers)
        { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
            } else if let response = response, (200..<300).contains(response.statusCode) {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func buyCart(products: [Product], shippingAddress: String, completion: @escaping(Bool) -> Void) {
        let parameters: Parameters = ["products": products, "shipping_address": shippingAddress]
        
        BackendService.shared.sendRequest(endpoint: "", method: .post, parameters: parameters, headers: headers) { data, response, error in
            if let error = error {
                print("Произошла ошибка: \(error)")
            } else if let response = response {
                switch response.statusCode {
                case 201:
                    print("Товары оплачены!")
                    completion(true)
                case 400...499:
                    print("Ошибка на стороне клиента. Статус код: \(response.statusCode)")
                    completion(false)
                case 500...599:
                    print("Ошибка на стороне сервера. Статус код: \(response.statusCode)")
                    completion(false)
                default:
                    print("Неожиданный код ответа: \(response.statusCode)")
                    completion(false)
                }
            }
        }
    }
    
    func fetchBuyersOrders(completion: @escaping ([Order]) -> Void) {
        let item1 = Product(
            id: 1, name: "Apple AirPods Pro 2", price: 22669.0,
            image: UIImage(named: "AirPods") ?? UIImage(),
            description: "AirPods Pro были переработаны для еще более насыщенного воспроизведения звука. Активное шумоподавление следующего уровня и адаптивная прозрачность снижают уровень внешних шумов. Пространственный звук выводит погружение на удивительно личный уровень. Сенсорное управление теперь позволяет регулировать громкость одним движением. А скачок в мощности обеспечивает 6 часов автономной работы от одного заряда.", category: "1", quantity: 1
        )
        let item2 = Product(
            id: 2, name: "Умная колонка Яндекс Станция Мини", price: 6999.0,
            image: UIImage(named: "alisa") ?? UIImage(),
            description: "Яндекс.Станция Мини - обновленная версия умной колонки с голосовым ассистентом Алиса. Данная модель получила более громкий звук мощностью 10 Вт. Колонка управляется не только голосом, но и с помощью сенсорных кнопок, расположенных сверху. Алиса по-прежнему умеет управлять 'Умным домом', подбирать музыку, знает много детских сказок, разбудит вовремя, расскажет новости или напомнит о важных делах. Станции Мини впишется в большинство интерьеров благодаря лаконичному дизайну и различным цветам. Подключается колонка к интернету по Wi-Fi, а Bluetooth 5.0 позволит подключать такие устройства, как умную лампу, пылесос и сотни других устройств.", category: "1", quantity: 2)
        
        let item7 = Product(
            id: 5, name: "Nike Air Max 95", price: 12990.0,
            image: UIImage(named: "95") ?? UIImage(),
            description: "Blabla", category: "1", quantity: 1
        )
        
        let order = Order(id: 1, product: item1, shippingAddress: "Ершова 62", status: "Получено", totalPrice: "21990", orderDate: "12.07.2023 12:02")
        let order2 = Order(id: 1, product: item2, shippingAddress: "Ершова 62", status: "Получено", totalPrice: "21990", orderDate: "12.07.2023 12:02")
        let order3 = Order(id: 1, product: item7, shippingAddress: "Ершова 62", status: "Получено", totalPrice: "21990", orderDate: "12.07.2023 12:02")
        completion([order, order2, order3])
    }
    
    func fetchSellersOrders(completion: @escaping ([Order]) -> Void) {
        let item7 = Product(
            id: 5, name: "Nike Air Max 95", price: 12999.0,
            image: UIImage(named: "95") ?? UIImage(),
            description: "blabla", category: "1", quantity: 1
        )
//
//        completion([product])
        
        let order = Order(id: 2, product: item7, shippingAddress: "Kosmos 62", status: "Получено", totalPrice: "21990", orderDate: "13.07.2023 15:24")
        completion([order])
    }
    
    func topUpBalance(amount: String, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(String(describing: UserCredentials.loadFromCoreData()?.accessToken))",
            "Content-type": "application/json"
        ]
        
        BackendService.shared.sendRequest(endpoint: "\(host)/topUp/\(amount)", method: .put, headers: headers) { data, response, error in
            if error == nil, let data = data {
                do {
                    let json = try JSONDecoder().decode([String: String].self, from: data)
                    if json["status"] == "success" {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    print("Error decoding response: \(error)")
                    completion(false)
                }
            } else {
                print("Error topping up balance: \(error?.localizedDescription ?? "No data")")
                completion(false)
            }
        }
    }

    func getBalance(completion: @escaping (Double?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(String(describing: UserCredentials.loadFromCoreData()?.accessToken))",
            "Content-type": "application/json"
        ]
        
        BackendService.shared.sendRequest(endpoint: "\(host)/balance", method: .get, headers: headers) { data, response, error in
            guard error == nil, let data = data else {
                print("Error getting balance: \(error?.localizedDescription ?? "No data")")
                return
            }

            do {
                let json = try JSONDecoder().decode([String: Double].self, from: data)
                if let balance = json["Balance"] {
                    completion(Double(balance))
                }
            } catch {
                print("Error decoding balance: \(error)")
            }
        }
    }
    
    
    
    func getAllSellers(completion: @escaping ([Seller]) -> Void) {
        let sellers: [Seller] = [Seller(id: 1, name: "Илья Гребеньков"), Seller(id: 2, name: "Новый продавец"), Seller(id: 3, name: "Apple")]
        completion(sellers)
    }
    
    func editProduct(image: UIImage, name: String, description: String,
                     price: String, category: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
