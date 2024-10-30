//
//  Restaurant.swift
//  NearFood
//
//  Created by Kunwar Vats on 30/10/24.
//

import SwiftUI
import Foundation

// MARK: - YelpResults
struct YelpResults: Codable {
    let businesses: [Business]
    let total: Int
}

// MARK: - Business
struct Business: Codable, Identifiable {
    let id, alias, name: String
    let imageUrl: String
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Double
    let coordinates: Center
    let location: Location
    let phone, displayPhone: String
    let distance: Double
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image_url"
        case reviewCount = "review_count"
        case displayPhone = "display_phone"
        case id, alias, name, url, categories, rating, coordinates, location, phone, distance
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String
}

// MARK: - Center
struct Center: Codable {
    let latitude, longitude: Double
}

// MARK: - Location
struct Location: Codable {
    let address1: String
    let address2: String?
    let zipCode: String
    let displayAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case zipCode = "zip_code"
        case displayAddress = "display_address"
        case address1, address2
    }

}
