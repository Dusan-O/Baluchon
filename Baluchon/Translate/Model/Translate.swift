//
//  Translate.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import UIKit

class Translation {
    
    let session: RequestInterface
    
    let apiKey: String
    
    // Default arguments in function
    init(session: RequestInterface = URLSession.shared,
         apiKey: String = APIKeys.translation) {
        self.session = session
        self.apiKey = apiKey
    }
    
    // MARK: - Function request + API
    
    // Use of URLComponents to construct the URL with the required parameters to request to Google API translation
    func request(from: String, then: @escaping (Result<String, TranslationError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "translation.googleapis.com"
        urlComponents.path = "/language/translate/v2"
        
        urlComponents.queryItems = [URLQueryItem(name: "q", value: from),
                                    URLQueryItem(name: "target", value: "en"),
                                    URLQueryItem(name: "format", value: "text"),
                                    URLQueryItem(name: "key", value: apiKey)]
        
        
        /// If this fail, it's because a programming error -> wrong URL
        guard let url = urlComponents.url else {
            fatalError("Invalid URL")
        }
        
        /// Sets the request as POST
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
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
                let responseJSON = try? JSONDecoder().decode(LatestTranslationResponse.self, from: data) else {
                    DispatchQueue.main.async {
                        then(.failure(.invalidResponseFormat))
                    }
                    return
            }
            
            /// if both condition above are satisfied, it provides an instance of LatestWeatherResponse object, which reprensents the response received from the server, along with the Result's success case back to the caller
            DispatchQueue.main.async {
                if let translatedText = responseJSON.data.translations.first?.translatedText {
                     then(.success(translatedText))
                } else {
                     then(.failure(.invalidResponseFormat))
                }
            }
        })
        task.resume()
    }
}
