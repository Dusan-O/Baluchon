//
//  CurrencyConverter.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import Foundation

class CurrencyConverter {
    
    struct LatestRateAndDate {
        var usdRate: Double
        var requestDate: String
    }
    
    var latestRateAndDate: LatestRateAndDate?
    
    let session: RequestInterface
    
    let apiKey: String
    
    // Default arguments in function
    init(session: RequestInterface = URLSession.shared,
         apiKey: String = APIKeys.currency) {
        self.session = session
        self.apiKey = apiKey
    }
    
    // MARK: - Function convert

    func convert(from: String, then: @escaping (Result<Double, CurrencyConverterError>) -> Void) {
        
        /// Verify if the String can be converter to a Double, if not, a error message will be displayed.
        guard let value = convertToDouble(from: from, locale: Locale(identifier: "fr_FR"))
            else {
                then(.failure(.invalidInput))
                return
        }
        
        /// Verify if the latest request was made the same day, to do the conversion with the latest known rate received, otherwise, to process to a new request
        if let latestRateAndDate = latestRateAndDate, wasRequestMadeToday(requestDate: latestRateAndDate.requestDate) {
            
            let usdValue = value * latestRateAndDate.usdRate
            DispatchQueue.main.async {
                then(.success(usdValue))
            }
        } else {
            request(from: value, then: then)
        }
    }
    
    // MARK: - Function request + API
    
    // Use of URLComponents to construct the URL with the required parameters to request to fixer API info about a currency
    func request(from: Double, then: @escaping (Result<Double, CurrencyConverterError>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "data.fixer.io"
        urlComponents.path = "/api/latest"
        
        //parameters
        urlComponents.queryItems = [URLQueryItem(name: "access_key", value: apiKey),
                                    URLQueryItem(name: "base", value: "eur"),
                                    URLQueryItem(name: "symbols", value: "usd")]
        
        // If this fail, it's because a programming error -> wrong URL
        guard let url = urlComponents.url else {
            fatalError("Invalid URL")
        }
        
        // Sets the request as GET
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            /// Verifies if the request threw an error
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    then(.failure(.requestError(error)))
                }
                return
            }
             /// Verifies that the received JSON in the server response has a format that we expect
            guard let data = data,
                let responseJSON = try? JSONDecoder().decode(LatestCurrencyResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        then(.failure(.invalidResponseFormat))
                    }
                    return
            }
            
            guard let usdRate = responseJSON.rates["USD"] else {
                DispatchQueue.main.async {
                    then(.failure(.usdRateNotFound))
                }
                return
            }
            
            self.latestRateAndDate = LatestRateAndDate(usdRate: usdRate, requestDate: responseJSON.date)
            
              /// if both condition above are satisfied, it provides an instance of LatestWeatherResponse object, which reprensents the response received from the server, along with the Result's success case back to the caller
            let usdValue = from * usdRate
            DispatchQueue.main.async {
                then(.success(usdValue))
            }
        })
        task.resume()
    }
    
    // Use to format today's date and compare it with a given date
    func wasRequestMadeToday(requestDate: String) -> Bool {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        return formattedDate == requestDate
    }
    
    // Use to convert a curreny to a Double
    func convertToDouble(from currency: String, locale: Locale) -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = locale
        return numberFormatter.number(from: currency)?.doubleValue
    }
}
