//
//  WeatherDisplayVIew.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import SwiftUI

struct WeatherDisplayView: View {
   
    @Environment(SearchViewModel.self) private var searchVM
    var location : String
    let weatherAPI = WeatherAPIService.shared
    
    
    init(location: String) {
        self.location = location
    }
    var body: some View {
        VStack {
            Image(systemName: "rainbow")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(location)
        }
        .onAppear {
            queryWeather(for: location)
        }
    }
    
    //Search WeatherMapAPI on Submit
    //TODO: Decode the epoch times. Can do it inline?
    private func queryWeather(for loc: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MM/dd"
        
        weatherAPI.queryWeather(location: loc) { result in
            switch result {
            case .success(let result):
                for w in result.weather {
                    print("Weather: \(w.description)")
                    print(dateFormatter.string(from: result.dt))
                    print("Temp: \(result.main.temp)")
                    print("Feels Like: \(result.main.feelsLike)")
                    print("Humidity: \(result.main.temp)")
                    print("Min: \(result.main.temp)")
                    print("Max: \(result.main.temp)")
                    print("IconURL: \(w.iconURL)")
                }
                //print("Result: \(result)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    WeatherDisplayView(location: "Dallas, US")
        .environment(SearchViewModel())
}
