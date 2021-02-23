//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 21/02/21.
//

import Foundation
import CoreLocation

struct CityWeatherModel: Codable {
    let id: Int64
    let name: String
    let timezone: Int64
    let cod: Int32
    let dt: Int64
    let visibility: Int64
    let coordinate: Coordinate?
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    let weathers : [WeatherInfo]
    
    enum CodingKeys: String, CodingKey {
        case id
        case clouds
        case cod
        case coordinate = "coord"
        case dt
        case main
        case name
        case sys
        case timezone
        case visibility
        case weathers = "weather"
        case wind
    }
    
    var getWeatherDisplayInfos: [WeatherDisplayInfoStruct] {
        let temperatureString  = self.main.getCurrentTemperatureString
        let dateAndTimeString = "--"
        var infos = [WeatherDisplayInfoStruct]()
        for weather in weathers {
            infos.append(WeatherDisplayInfoStruct(iconUrl: weather.getIconUrl,
                                                  weatherCondition: weather.main,
                                                  detailedWeatherCondition: weather.description,
                                                  temperatureString: temperatureString,
                                                  dateAndTimeString: dateAndTimeString))
        }
        return infos
    }
    
}

struct Coordinate: Codable {
    let lat: Double
    let lon: Double
    
    /*
     lat = "-16.9167";
     lon = "145.7667";
     */
    
}

struct Main: Codable {
    let currentTemperature: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    let minTemperatureInCity: Double?
    let maxTemperatureInCity: Double?
    
    enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case humidity
        case pressure
        case minTemperatureInCity = "temp_min"
        case maxTemperatureInCity = "temp_max"
        case feelsLike = "feels_like"
        
    }
    
    var getCurrentTemperatureString: String {
        return UtilityClass.shared.getTemperatureString(currentTemperature, fromInputUnit: .kelvin, toOutputUnit: .celsius)
    }
    
    var getMinTemperatureString: String? {
        guard let minTemperatureInCity = minTemperatureInCity  else {
            return nil
        }
        return UtilityClass.shared.getTemperatureString(minTemperatureInCity, fromInputUnit: .kelvin, toOutputUnit: .celsius)
    }
    
    var getMaxTemperatureString: String? {
        guard let maxTemperatureInCity = maxTemperatureInCity  else {
            return nil
        }
        return UtilityClass.shared.getTemperatureString(maxTemperatureInCity, fromInputUnit: .kelvin, toOutputUnit: .celsius)
    }
    
    /*
     "feels_like" = "307.76";
     humidity = 74;
     pressure = 1004;
     temp = "303.43";
     "temp_max" = "303.71";
     "temp_min" = "303.15";
     */
    
}

struct Wind: Codable {
    let speed: Float
    let deg: Float
    
    var getSpeedInKmAndHrString: String {
        let speedInHr = (speed * 60 * 60) / 100
        return String(format: "%.2f Km/Hr", speedInHr)
    }
    
    var getDegreeString: String {
        return String(format: "%.2f °", deg)
    }
    
    
    /*
     deg = 20;
     speed = "3.09";
     */
}

struct Clouds: Codable {
    let all: Float
    /*
     all = 8;
     */
}

struct Sys: Codable {
    let id: Int64?
    let type: Int?
    let country: String? 
    let sunrise: Int64
    let sunset: Int64
    
    /*
     country = AU;
     id = 9490;
     sunrise = 1614024888;
     sunset = 1614069973;
     type = 1;
     */
    
}

struct WeatherInfo: Codable {
    let id: Int64
    let main: String
    let description: String
    let icon: String
    
    var getIconUrl: URL {
        return IconImagUrl.getImageIconUrlForIconName(icon)
    }
    
    /*
     description = "clear sky";
     icon = 01d;
     id = 800;
     main = Clear;
     */
        
}


//Sample JSON.
/*
 {
     base = stations;
     clouds =     {
         all = 8;
     };
     cod = 200;
     coord =     {
         lat = "-16.9167";
         lon = "145.7667";
     };
     dt = 1614065252;
     id = 2172797;
     main =     {
         "feels_like" = "307.76";
         humidity = 74;
         pressure = 1004;
         temp = "303.43";
         "temp_max" = "303.71";
         "temp_min" = "303.15";
     };
     name = Cairns;
     sys =     {
         country = AU;
         id = 9490;
         sunrise = 1614024888;
         sunset = 1614069973;
         type = 1;
     };
     timezone = 36000;
     visibility = 10000;
     weather =     (
                 {
             description = "clear sky";
             icon = 01d;
             id = 800;
             main = Clear;
         }
     );
     wind =     {
         deg = 20;
         speed = "3.09";
     };
 }
 */
