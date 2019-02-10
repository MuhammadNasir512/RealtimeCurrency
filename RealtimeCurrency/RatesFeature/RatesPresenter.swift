import UIKit

protocol RatesPresenterType {
    func startLoadingCurrencyData()
    func stopLoadingCurrencyData()
}

final class RatesPresenter: RatesPresenterType {

    let timer: RealtimeTimerType
    let apiHandler: APIHandlerType
    let ratesParser: RatesParserType
    var currencyCellModels = [CurrencyCellModel]()
    weak var viewController: RatesViewController?
    
    init(
        timer: RealtimeTimerType = RealtimeTimer(),
        apiHandler: APIHandlerType = APIHandler(),
        ratesParser: RatesParserType = RatesParser()
        ) {
        self.timer = timer
        self.apiHandler = apiHandler
        self.ratesParser = ratesParser
    }
    
    func startLoadingCurrencyData() {
        timer.startTimer { [weak self] in
            guard let `self` = self else { return }
            self.makeAPICall()
        }
    }
    
    func stopLoadingCurrencyData() {
        timer.stopTimer()
    }
    
    private func makeAPICall() {
        apiHandler.getRates(success: { [weak self] data in
            guard let `self` = self else { return }
            self.parseRates(currencyData: data)
        }) { error in
            
        }
    }
    
    private func parseRates(currencyData: Data) {
        let sortedValues = ratesParser.rates(currencyData: currencyData).sorted(by: { $0.0 < $1.0 })
        var newCellModels = [CurrencyCellModel]()
        for (currencyCode, rate) in sortedValues {
            newCellModels.append(createCurrencyCellModel(currencyCode: currencyCode, rate: rate))
        }
        
        guard
            !currencyCellModels.isEmpty,
            let index = currencyCellModels.index(where: { $0.isEditing == true }) else {
            currencyCellModels = newCellModels
            viewController?.reloadData(currencyCellModels: currencyCellModels)
            return
        }
        
        let currentlyEditingModel = currencyCellModels[index]
        if let newEditingModel = newCellModels.first(where: { $0.code == currentlyEditingModel.code }) {
            
            newEditingModel.isEditing = true

            let index = newCellModels.index(where: { $0.isEditing == true }) ?? 0
            newCellModels.remove(at: index)
            newCellModels.insert(newEditingModel, at: 0)

            newEditingModel.calculatedRate = Double(round(1000*currentlyEditingModel.calculatedRate)/1000)

            for model in newCellModels {
                model.calculatedRate = model.rate / newEditingModel.rate * newEditingModel.calculatedRate
                model.calculatedRate = Double(round(1000*model.calculatedRate)/1000)
            }
        }
        currencyCellModels = newCellModels
        viewController?.reloadData(currencyCellModels: currencyCellModels)
    }
    
    private func createCurrencyCellModel(currencyCode: String, rate: Double) -> CurrencyCellModel {
        let model = CurrencyCellModel(code: currencyCode, rate: rate)
        model.textFieldValueChanged = { value in
            model.calculatedRate = value
            for modelItem in self.currencyCellModels {
                modelItem.calculatedRate = modelItem.rate / model.rate * model.calculatedRate
                modelItem.calculatedRate = Double(round(1000*modelItem.calculatedRate)/1000)
           }
            self.viewController?.reloadData(currencyCellModels: self.currencyCellModels)
        }
        return model
    }
}
