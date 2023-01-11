//
//  APIRouter.swift
//  Weather
//
//  Created by Nidhi patel on 09/01/23.
//

import Foundation

struct APIRouter {
    static let shared = APIRouter()
    
    //MARK: - Append query Items
    func getUrlItem(key : String , cityName : String) -> [URLQueryItem]? {
      var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name:API.APIParameterKey.key, value:key))
        queryItems.append(URLQueryItem(name:API.APIParameterKey.q, value:cityName))
        queryItems.append(URLQueryItem(name:API.APIParameterKey.days, value:"7"))
        queryItems.append(URLQueryItem(name:API.APIParameterKey.aqi, value:"no"))
        queryItems.append(URLQueryItem(name:API.APIParameterKey.alerts, value:"no"))
      return queryItems
    }
    
    //MARK: - Method to get data from weather API
    func getWeatherDataFromCity(key : String , cityName : String , completion : @escaping () -> ()) {
        var urlComponents = URLComponents(string:API.Url.baseUrl)
        urlComponents?.queryItems = self.getUrlItem(key:key, cityName:cityName)
        let url = (urlComponents?.url)!
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with:request) { data , response , error in
            
            if let data = data {
                let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
                weatherDict = responseObject!
                userDefaults.set(weatherDict, forKey: APIKeys.weatherData)
                completion()
            }
        }
        task.resume()
    }
    
}
