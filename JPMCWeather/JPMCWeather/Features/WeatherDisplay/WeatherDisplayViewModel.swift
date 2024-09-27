//
//  WeatherDisplayViewModel.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/25/24.
//

import Foundation
import SwiftUICore
@Observable class WeatherDisplayViewModel {
    //var weather: WeatherConditionsModel
    //let weatherAPI = WeatherAPIService.shared
    
    var location : String
    
    init(location: String) {
        self.location = location
        //self.weather = WeatherConditionsModel()
    }
}
   
