import UIKit


enum SettingsOption: Int, CaseIterable {
    case account = 0
    case myProducts
    case ordersHistory
    case balance
    case darkMode
    case aboutApp
    
    var title: String {
        switch self {
        case .account: return "Аккаунт"
        case .myProducts: return "Мои товары"
        case .ordersHistory: return "История заказов"
        case .balance: return "Баланс"
        case .darkMode: return "Темная тема"
        case .aboutApp: return "О приложении"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .account: return UIImage(systemName: "person")
        case .myProducts: return UIImage(systemName: "list.clipboard")
        case .ordersHistory: return UIImage(systemName: "list.clipboard")
        case .balance: return UIImage(systemName: "rublesign")
        case .darkMode: return UIImage(systemName: "ellipsis.circle")
        case .aboutApp: return UIImage(systemName: "newspaper")
        }
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        switch self {
        case .darkMode: return .none
        default: return .disclosureIndicator
        }
    }
}
