//
//  CurrencyConverterError.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import Foundation

//typed errors
enum CurrencyConverterError: Error, Equatable {
    case requestError(NSError)
    case invalidResponseFormat
    case usdRateNotFound
    case invalidInput
}

// MARK: - CURRENCY CONVERTOR - Error

extension CurrencyConverterError {
    var message: String{
        switch self {
        case let .requestError(error):
            return error.localizedDescription
        case .invalidResponseFormat:
            return "Le format de réponse du serveur est invalide "
        case .usdRateNotFound:
            return "La devise $ n'est pas disponible"
        case .invalidInput:
            return "Entrez un montant valide"
        }
    }
}
