//
//  MainSearchModel.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import Foundation

//Model for Location
struct Location: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var country: String
    var lat: Double
    var lon: Double
    
    //For List display
    var description: String {
        "\(name), \(country)"
    }
}

//Model for Locations
struct SearchModel: Codable {
    var locations: [Location] = [
        Location(name: "New York", country: "US", lat: 40.7128, lon: -74.0060),
        Location(name: "Los Angeles", country: "US", lat: 34.0522, lon: -118.2437),
        Location(name: "Chicago", country: "US", lat: 41.8781, lon: -87.6298),
        Location(name: "Houston", country: "US", lat: 29.7604, lon: -95.3698),
    ]
}


