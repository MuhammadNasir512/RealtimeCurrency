import UIKit

final class RatesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let presenter = RatesPresenter()
    private let dataSource = RatesDataSource()
    private var currencyCellModels = [CurrencyCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        dataSource.viewController = self
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.startLoadingCurrencyData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter.stopLoadingCurrencyData()
        super.viewWillDisappear(animated)
    }
    
    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        tableView.register(UINib(nibName: "CurrencyCell", bundle: nil), forCellReuseIdentifier: "CurrencyCell")
    }
    
    func reloadData(currencyCellModels: [CurrencyCellModel]) {
        self.currencyCellModels = currencyCellModels
        dataSource.currencyCellModels = currencyCellModels
        tableView.reloadData()
        
        if let index = currencyCellModels.firstIndex(where: { $0.isEditing == true }),
            let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? CurrencyCell {
            let indexPath = IndexPath(row: index, section: 0)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
            cell.focusTextField()
        }
    }
    
    func updateCellModels(currencyCellModels: [CurrencyCellModel]) {
        self.currencyCellModels = currencyCellModels
        presenter.currencyCellModels = currencyCellModels
    }
}
