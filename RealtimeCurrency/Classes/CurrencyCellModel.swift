import Foundation

class CurrencyCellModel {
    
    let name: String
    let code: String
    var rate: Double
    var calculatedRate: Double
    var isEditing = false
    var textFieldValueChanged: ((Double) -> Void)?

    init(code: String, rate: Double) {
        self.code = code
        self.rate = Double(round(1000*rate)/1000)
        calculatedRate = Double(round(1000*rate)/1000)
        guard let currencyName = CurrencyCode(rawValue: code)?.currencyName() else { name = "Unknown"; return }
        name = currencyName
    }
}

enum CurrencyCode: String {
    case AUD
    case BGN
    case BRL
    case CAD
    case CHF
    case CNY
    case CZK
    case DKK
    case GBP
    case HKD
    case HRK
    case HUF
    case IDR
    case ILS
    case INR
    case ISK
    case JPY
    case KRW
    case MXN
    case MYR
    case NOK
    case NZD
    case PHP
    case PLN
    case RON
    case RUB
    case SEK
    case SGD
    case THB
    case TRY
    case USD
    case ZAR

    func currencyName() -> String {
        switch self {
        case .AUD: return "Australian dollar"
        case .BGN: return "Bulgarian lev"
        case .BRL: return "Brazilian real"
        case .CAD: return "Canadian dollar"
        case .CHF: return "Swiss franc"
        case .CNY: return "Chinese yuan"
        case .CZK: return "Czech koruna"
        case .DKK: return "Danish krone"
        case .GBP: return "British pound"
        case .HKD: return "Hong Kong dollar"
        case .HRK: return "Croatian kuna"
        case .HUF: return "Hungarian forint"
        case .IDR: return "Indonesian rupiah"
        case .ILS: return "Israeli new shekel"
        case .INR: return "Indian rupee"
        case .ISK: return "Icelandic króna"
        case .JPY: return "Japanese yen"
        case .KRW: return "South Korean won"
        case .MXN: return "Mexican peso"
        case .MYR: return "Malaysian ringgit"
        case .NOK: return "Norwegian krone"
        case .NZD: return "New Zealand dollar"
        case .PHP: return "Philippine peso"
        case .PLN: return "Polish złoty"
        case .RON: return "Romanian leu"
        case .RUB: return "Russian ruble"
        case .SEK: return "Swedish krona"
        case .SGD: return "Singapore dollar"
        case .THB: return "Thai baht"
        case .TRY: return "Turkish lira"
        case .USD: return "United States dollar"
        case .ZAR: return "South African rand"
        }
    }
}
