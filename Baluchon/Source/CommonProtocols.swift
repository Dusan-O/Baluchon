//
//  CommonProtocols.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import Foundation

// Auxiliar protocol that copies URLSession's dataTask function signature for testing purposes(to define mock types that conform to this protocol)
protocol RequestInterface {
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: RequestInterface {}
