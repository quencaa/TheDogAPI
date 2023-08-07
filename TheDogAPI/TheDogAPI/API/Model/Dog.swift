//
//  DogImage.swift
//  TheDogAPI
//
//  Created by Gustavo Quenca on 02/08/2023.
//

import Foundation

struct Dog: Codable {
    let id: String
    let url: String?
    let width: Int?
    let height: Int?
    
    var breeds: [Breed]?
}

struct Breed: Codable {
    let weight: Weight?
    let id: Int
    let name: String?
    let temperament: String?
    let origin: String?
    let countryCodes: String?
    let countryCode: String?
    let lifeSpan: String?
    let wikipediaUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case weight
        case id
        case name
        case temperament
        case origin
        case countryCodes = "country_codes"
        case countryCode = "country_code"
        case lifeSpan = "life_span"
        case wikipediaUrl = "wikipedia_url"
    }
}

struct Weight: Codable {
    let imperial: String?
    let metric: String?
}
