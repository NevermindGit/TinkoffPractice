import UIKit

class BaseTextField: UITextField, UITextFieldDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        backgroundColor = .lightGray.withAlphaComponent(0.2)
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderWidth = 0
        delegate = self

        leftViewMode = .always
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        leftView = paddingView
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateBorderWidth(to: 2, borderColor: UIColor.systemGray2.withAlphaComponent(0.5).cgColor)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        animateBorderWidth(to: 0)
    }

    private func animateBorderWidth(to width: CGFloat, borderColor: CGColor? = nil) {
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor
        }

        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseInOut
        ) {
            self.layer.borderWidth = width
        }
    }

}
