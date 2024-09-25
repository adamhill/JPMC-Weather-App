//
//  MainSearchViewModel.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/24/24.
//

import Foundation
import SwiftUICore

@Observable class SearchViewModel {
    var searchModel: SearchModel = SearchModel()
    var weatherConditionsModel: WeatherConditionsModel?
    //@State var lastCityShown: String = "Dallas, US"
    @State  @ObservationIgnored var lastCityShown: String = "Dallas, US"

    //TODO: Load previous location list
    
    enum APIError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case httpError(Int)
        case decodingError(Error)
    }
    func queryWeather(query: String, completion: @escaping (Result<WeatherConditionsModel, APIError>) -> Void) {
        
        //TODO: Validate the querystring - null or empty, only alpha
        guard !query.isEmpty else {
            print("Query is empty")
            return
            //Location(id: UUID(), name: "", country: "", lat: 0.0, lon: 0.0)
        }
        
        //Setup the URL & Request
        
        //HACK: NEVER STORE CREDENTIALS IN THE SOURCE CODE
        //TODO: Nice to have - Put the credentials somehwere more secure
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(query)&appid=476060addfbb6367f054ce5fb40d2ec1") else {
            completion(.failure(.invalidURL))
            return
        }
        let request = URLRequest(url: url)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle request errors
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }
            //Make sure we got a valid HTTPResponse
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            // Make sure we got a 2xxx something StatusCode
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(httpResponse.statusCode)))
                return
            }
            //Make sure we got some data
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let weatherConditions = try JSONDecoder().decode(WeatherConditionsModel.self, from: data)
                completion(.success(weatherConditions))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError)))
            }
            //Create a session and call the endpoint
            //TODO: Guard it
            //TODO: Throw exceptions
            //TODO: Handle non 200 reponses
            //        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //            if let data = data {
            //                if let decodedResponse = try? JSONDecoder().decode(WeatherConditionsModel.self, from: data) {
            //                    DispatchQueue.main.async {
            //                        self.weatherConditionsModel = decodedResponse
            //                    }
            //
            //                    return
            //                }
            //            }
            //    } catch DecodingError.dataCorrupted(let context) {
            //        print(context)
            //    } catch DecodingError.keyNotFound(let key, let context) {
            //        print("Key '\(key)' not found:", context.debugDescription)
            //        print("codingPath:", context.codingPath)
            //    } catch DecodingError.valueNotFound(let value, let context) {
            //        print("Value '\(value)' not found:", context.debugDescription)
            //        print("codingPath:", context.codingPath)
            //    } catch DecodingError.typeMismatch(let type, let context) {
            //        print("Type '\(type)' mismatch:", context.debugDescription)
            //        print("codingPath:", context.codingPath)
            //    } catch {
            //        print("error: ", error)
            //    }
        }
        
        task.resume()
        //        return Location(id: UUID(), name: "Fobus", country: "Foobar", lat: 1.0, lon: -90.0)
        
    }
}
