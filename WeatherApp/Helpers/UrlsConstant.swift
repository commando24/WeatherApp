//
//  UrlsConstant.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import Foundation

struct IconImagUrl {
    
    static let baseUrl = URL(string: "http://openweathermap.org/img/wn")!
    
    static func getImageIconUrlForIconName(_ name: String) -> URL {
        return baseUrl.appendingPathComponent("\(name)@2x.png")
    }
    
}
