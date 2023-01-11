//
//  Constant.swift
//  Weather
//
//  Created by Nidhi patel on 09/01/23.
//

import Foundation

var cityName = "Ahmedabad"
var key = "522db6a157a748e2996212343221502"
var weatherDict = [String : Any]()
var hoursDict = [[String : Any]]()

// Access Shared Defaults Object
let userDefaults = UserDefaults.standard

struct DictKeys {
    static var current = "current"
    static var condition = "condition"
    static var icon  = "icon"
    static var temp_c = "temp_c"
    static var location = "location"
    static var country = "country"
    static var localTime = "localtime"
    static var forecast = "forecast"
    static var foreCastDay = "forecastday"
    static var day = "day"
    static var maxtemp_c = "maxtemp_c"
    static var mintemp_c = "mintemp_c"
    static var date = "date"
    static var error = "error"
    static var message = "message"
    static var hour = "hour"
    static var time = "time"
}

struct Identifiers {
    static var ForeCastCell = "ForeCastCell"
    static var ForeCastCurrentCell = "ForeCastCurrentCell"
}

struct Titles {
    static var forecast = "Forecast"
}

struct APIKeys {
    static var weatherData = "weatherData"
}
