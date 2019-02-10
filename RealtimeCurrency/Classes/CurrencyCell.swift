import UIKit

final class CurrencyCell: UITableViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var textField: UITextField!
    var model: CurrencyCellModel?

    func reload(with model: CurrencyCellModel) {
        self.model = model
        selectionStyle = .none
        titleLabel.text = model.code
        subtitleLabel.text = model.name
        textField.text = "\(model.calculatedRate)"
    }
    
    func focusTextField() {
        textField.becomeFirstResponder()
    }

    func textFieldValue() -> Double {
        guard let text = textField.text else { return 0 }
        return Double(text) ?? 0
    }
    
    @IBAction func textFieldEditingChanged() {
        model?.textFieldValueChanged?(textFieldValue())
    }
}

extension CurrencyCell: UITextFieldDelegate {
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return true }
        let text = textField.text ?? ""
        let oldString = text as NSString
        let candidate = oldString.replacingCharacters(in: range, with: string)
        let regex = try? NSRegularExpression(pattern: "^([0-9]+)\\.?([0-9]{1,8})?$", options: [])
        return regex?.firstMatch(in: candidate, options: [], range: NSRange(location: 0, length: (candidate.count))) != nil
    }
 */
}
