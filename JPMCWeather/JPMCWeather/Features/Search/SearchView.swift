//
//  ContentView.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import SwiftUI

struct SearchView: View {
    
    //Datasource
    @Environment(SearchViewModel.self) private var searchVM
    @State var searchResults: [Location] = []
    @State var searchQuery: String = ""
    var isSearching: Bool {
        return !searchQuery.isEmpty
    }
    
    var body: some View {
        
        VStack {
            
            NavigationStack {
                List {
                    if isSearching {
                        ForEach(searchResults) { location in
                            NavigationLink("\(location.description)", value: location.description)
                        }
                    } else {
                        ForEach(searchVM.searchModel.locations) { location in
                            NavigationLink("\(location.description)", value: location.description)
                        }
                    }
                }
                .navigationDestination(for: String.self) { loc in
                    WeatherDisplayView(location: loc)
                        .environment(searchVM)
                }
                .navigationTitle("Recent Searches")
                .searchable(
                    text: $searchQuery,
                    placement: .automatic,
                    prompt: "US City"
                )
                .textInputAutocapitalization(.never)
                //Filter the list
                .onChange(of: searchQuery){
                    self.filterExistingLocations(for: searchQuery)
                }
                //Search for a City
                .onSubmit(of: .search) {
                    queryWeather(for: searchQuery)
                }
                //Empty state
                .overlay {
                    if isSearching && searchResults.isEmpty {
                        ContentUnavailableView(
                            "No locations match",
                            systemImage: "magnifyingglass",
                            description: Text("No Locations matching **\\(searchQuery)**")
                        )
                    }
                }
            }
        }
    }
    
    // Search existing Locations
    private func filterExistingLocations(for query: String) {
        searchResults = searchVM.searchModel.locations.filter {
            $0.name.lowercased().contains(query.lowercased())
        }
    }
    
    //Search WeatherMapAPI on Submit
    private func queryWeather(for query: String) {
        searchVM.queryWeather(query: query) { result in
            switch result {
            case .success(let result):
                let newCity = Location(name: result.name, country: result.sys.country, lat: result.coord.lat, lon: result.coord.lon)
                searchVM.searchModel.locations.append(newCity)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    SearchView().environment(SearchViewModel())
}
