//
//  APIConstant.swift
//  Weather
//
//  Created by Nidhi patel on 09/01/23.
//

import Foundation

struct API {
    //MARK:- Url
    struct Url {
        static let baseUrl = "https://api.weatherapi.com/v1/forecast.json"
    }
    
    //MARK: - Keys for parameters or queryItem
    struct APIParameterKey {
       static let key = "key"
       static let q = "q"
       static let days = "days"
       static let aqi = "aqi"
       static let alerts = "alerts"
    }
}
