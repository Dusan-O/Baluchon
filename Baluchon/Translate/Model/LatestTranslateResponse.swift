//
//  LatestTranslateResponse.swift
//  Baluchon
//
//  Created by Dusan Orescanin on 29/03/2022.
//

import Foundation

// Represents the JSON response for the Google API to get translation information of a text. The JSON structure is represented by the the different structs defined in this file
struct LatestTranslationResponse: Codable {
    
    let data: DataResponse
}

struct DataResponse: Codable {
    
    let translations: [TranslatedTextResponse]
}

struct TranslatedTextResponse: Codable {

    let translatedText: String
}
