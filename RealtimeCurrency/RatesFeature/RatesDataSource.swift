import UIKit

final class RatesDataSource: NSObject {
    
    var currencyCellModels = [CurrencyCellModel]()
    weak var viewController: RatesViewController?
    
    func rowSelected(in tableView: UITableView, at indexPath: IndexPath) {
        let cellModel = currencyCellModels[indexPath.row]
        let newIndexPath = IndexPath(row: 0, section: indexPath.section)
        tableView.moveRow(at: indexPath, to: newIndexPath)
        
        currencyCellModels.filter { $0.isEditing == true }.forEach { $0.isEditing = false }
        cellModel.isEditing = true
        
        currencyCellModels.remove(at: indexPath.row)
        currencyCellModels.insert(cellModel, at: newIndexPath.row)
        viewController?.updateCellModels(currencyCellModels: currencyCellModels)
        
        tableView.scrollToRow(at: newIndexPath, at: UITableView.ScrollPosition.top, animated: true)
        
        guard let cell = tableView.cellForRow(at: newIndexPath) as? CurrencyCell else { return }
        cell.focusTextField()
    }
}

extension RatesDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellOptional = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath as IndexPath)
        guard let cell = cellOptional as? CurrencyCell else { return UITableViewCell() }
        let cellModel = currencyCellModels[indexPath.row]
        if !cellModel.isEditing {
            cell.reload(with: cellModel)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }
}

extension RatesDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected(in: tableView, at: indexPath)
    }
}

extension RatesDataSource: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currencyCellModels.filter { $0.isEditing == true }.forEach { $0.isEditing = false }
    }
}
