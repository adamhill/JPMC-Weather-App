//
//  MainIView.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import SwiftUI

enum Tab {
    case search
    case weather
}

struct MainView: View {
    //@State private var searchVM = SearchViewModel()
    
    @Environment(SearchViewModel.self) private var searchVM
    @State var activeTab = Tab.search
        
    var body: some View {
        TabView(selection: $activeTab) {
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
            WeatherDisplayView(location: searchVM.lastCityShown )
                .tabItem {
                    Label("Weather", systemImage: "cloud.sun")
                }
                
                .tag(Tab.weather)
        }
        .environment(searchVM)
    }
    func setCurrentTab(_ tab: Tab) {
        activeTab = tab
    }
}



#Preview {
    MainView()
        .environment(SearchViewModel())
    
}
