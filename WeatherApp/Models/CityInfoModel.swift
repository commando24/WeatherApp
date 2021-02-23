//
//  CityInfoModel.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import Foundation

struct CityInfoModel: Equatable, Hashable {
    
    let id : Int64
    let countryCode : String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case countryCode = "country"
        case name
    }
    
    init?(fromJSON json: [String: Any]) {
        guard let id = json["id"] as? Int64,
              let countryCode = json["country"] as? String,
              let name = json["name"] as? String else {
            return nil
        }
        self.id = id
        self.countryCode = countryCode
        self.name = name
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}



/*
 {
     "id": 14256,
     "coord": {
       "lon": 48.570728,
       "lat": 34.790878
     },
     "country": "IR",
     "geoname": {
       "cl": "P",
       "code": "PPL",
       "parent": 132142
     },
     "langs": [
       {
         "de": "Azad Shahr"
       },
       {
         "fa": "آزادشهر"
       }
     ],
     "name": "Azadshahr",
     "stat": {
       "level": 1,
       "population": 514102
     },
     "stations": [
       {
         "id": 7030,
         "dist": 9,
         "kf": 1
       }
     ],
     "zoom": 10
   },
 */
