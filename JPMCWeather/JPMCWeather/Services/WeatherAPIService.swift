//
//  WeatherAPIService.swift
//  JPMCWeather
//
//  Created by Adam Hill on 9/25/24.
//

import Foundation
class WeatherAPIService {
    
    static let shared = WeatherAPIService()
    
    enum APIError: Error {
        case invalidURL
        case requestFailed(Error)
        case invalidResponse
        case httpError(Int)
        case decodingError(Error)
    }
    
    func queryWeather(location: String, completion: @escaping (Result<WeatherConditionsModel, APIError>) -> Void) {
        guard !location.isEmpty else {
            print("Query is empty")
            return
        }
        //TODO: Validate the querystring - null or empty, only alpha
        let baseWeatherURL = "https://api.openweathermap.org/data/2.5/weather?q=\(location)&units=imperial&lang=en&appid=476060addfbb6367f054ce5fb40d2ec1"
        query(url: baseWeatherURL, completion: completion)
    }
    
//    func queryIcon(code: String, completion: @escaping (Result<WeatherIconModel, APIError>) -> Void) {
//        let baseIconURL = "https://openweathermap.org/img/wn/\(code)@2x.png"
//        query(query: baseIconURL, completion: completion)
//    }
    
    func query<T: Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void) {
        //DONE: Guard it
        //DONE: Throw exceptions
        //DONE: Handle non 200 reponses
        
        guard !url.isEmpty else {
            print("Query is empty")
            return
        }
        
        //Setup the URL & Request
        
        //HACK: NEVER STORE CREDENTIALS IN THE SOURCE CODE
        //TODO: Nice to have - Put the credentials somehwere more secure
        guard let url = URL(string: url) else {
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
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                let weatherConditions = try decoder.decode(T.self, from: data)
                completion(.success(weatherConditions))
            } catch let decodingError {
                completion(.failure(.decodingError(decodingError)))
            }
            
        }
        
        task.resume()
    }
}
