import Foundation

protocol RatesParserType {
    func rates(currencyData: Data) -> [String: Double]
}

final class RatesParser: RatesParserType {
    
    func rates(currencyData: Data) -> [String: Double] {
        do {
            let currency = try Currency(data: currencyData)
            return currency.rates
        }
        catch { return [:] }
    }
}
