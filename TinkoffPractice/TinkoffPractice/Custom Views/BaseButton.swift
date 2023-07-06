import UIKit

class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureButton() {
        backgroundColor = UIColor.systemYellow
        layer.cornerRadius = 14
        setTitleColor(.black, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }

}
