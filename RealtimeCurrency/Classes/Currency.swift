import UIKit

final class Currency: Codable {
    
    private let base: String
    let rates: [String: Double]
    
    init(base: String, rates: [String: Double]) {
        self.base = base
        self.rates = rates
    }
    
    convenience init(data: Data) throws {
        let currency = try JSONDecoder().decode(Currency.self, from: data)
        self.init(base: currency.base, rates: currency.rates)
    }
}
