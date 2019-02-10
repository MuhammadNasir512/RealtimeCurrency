import UIKit

protocol APIHandlerType {
    func getRates(success: @escaping (Data) -> (), failure: @escaping (Error) -> ())
}

final class APIHandler: APIHandlerType {
    
    let urlString: String

    init(urlString: String = "https://revolut.duckdns.org/latest?base=EUR") {
        self.urlString = urlString
    }
    
    func getRates(success: @escaping (Data) -> (), failure: @escaping (Error) -> ()) {
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "URLError", code: 99, userInfo: nil) as Error
            failure(error)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let error = error else {
                    let dataToSend = data ?? Data()
                    success(dataToSend)
                    return
                }
                failure(error)
            }
        }
        task.resume()
    }
}
