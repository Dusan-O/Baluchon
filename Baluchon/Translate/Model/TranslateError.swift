//
//  TranslateError.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import Foundation

enum TranslationError: Error, Equatable {
    case requestError(NSError)
    case invalidResponseFormat
}

// MARK: - TRANSLATE - Error

extension TranslationError {
    var message: String{
        switch self {
        case let .requestError(error):
            return error.localizedDescription
        case .invalidResponseFormat:
            return "Le format de réponse du serveur est invalide "
        }
    }
}
