//
//  WeatherDisplayVIew.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import SwiftUI

struct WeatherDisplayView: View {
    var location : String
    var body: some View {
        
        
        VStack {
            Image(systemName: "rainbow")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(location)
        }
    }
}

#Preview {
    WeatherDisplayView(location: "Dallas, US")
}
