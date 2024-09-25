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
    private func queryWeather(for loc: String) {
        weatherAPI.queryWeather(location: loc) { result in
            switch result {
            case .success(let result):
                print("Result: \(result)")
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
