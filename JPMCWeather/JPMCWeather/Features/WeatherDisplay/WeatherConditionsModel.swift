//
//  WeatherModel.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/25/24.
//

import Foundation

struct WeatherConditionsModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: CoreInfo
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Misc
    let timezone, id: Int
    let name: String

}

struct Coord: Codable {
    let lon, lat: Double
}
struct Weather: Codable {
    let main, description, icon: String
    //Yay  we have AsyncImage!
    var iconURL: URL {
        let url = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        return URL(string: url)!
    }
}

struct CoreInfo: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity, seaLevel, grndLevel: Int
    
    enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure, humidity
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
        }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust : Double?
}

struct Clouds: Codable {
    let all: Int
}

struct Misc: Codable {
    let country: String
    let sunrise, sunset: Int
}

