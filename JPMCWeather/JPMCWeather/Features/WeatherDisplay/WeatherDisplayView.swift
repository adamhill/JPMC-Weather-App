//
//  WeatherDisplayVIew.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import SwiftUI

struct WeatherDisplayView: View {
    
    @Environment(SearchViewModel.self) private var searchVM
    //var weatherDisplayVM: WeatherDisplayViewModel
    @State var weatherConditions : WeatherConditionsModel? = nil
    @State private var location : String
    let weatherAPI = WeatherAPIService.shared
    
    init(location: String) {
        self.location = location
    }
    var body: some View {
        VStack {
            if let weatherConditions = weatherConditions {
                HStack {
                    AsyncImage(url: weatherConditions.weather[0].iconURL)
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    Text(String(format: "%01.1f", weatherConditions.main.temp))
                        .font(.title)
                        .fontWeight(.bold)
                }
                VStack(alignment: .leading) {
                    Text(weatherConditions.fullLocation)
                    Text(weatherConditions.weather[0].description)
                    Text("Feels Like: \(String(format: "%01.1f",weatherConditions.main.feelsLike))")
                    HStack {
                        Text("Min: \(String(format: "%01.1f",weatherConditions.main.tempMin))")
                        Text("Max: \(String(format: "%01.1f",weatherConditions.main.tempMax))")
                    }
                   
                    Text("Humidity: \(String(format: "%01.1f",weatherConditions.main.humidity))")
                }
                
                
            }
            
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
                self.weatherConditions = result
                for w in weatherConditions!.weather {
                    print(weatherConditions!.fullLocation)
                    print("Weather: \(w.description)")
                    print(dateFormatter.string(from: result.dt))
                    print("Temp: \(result.main.temp)")
                    print("Feels Like: \(result.main.feelsLike)")
                    print("Humidity: \(result.main.temp)")
                    print("Min: \(result.main.temp)")
                    print("Max: \(result.main.temp)")
                    print("IconURL: \(w.iconURL)")
                }
                
                print("Result: \(result)")
                //print("Result: \(weatherConditions ?? "No conditions")")
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
