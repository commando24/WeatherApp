//
//  WeatherAPIHelper.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit
import Alamofire

struct OpenWeatherAPIEndPoint {
    
    static let appID = "Replace_Your_Key_Here"
    
    struct QueryParameters {
        static let id = "id"
        static let appid = "appid"
    }
    
    static let baseUrl = URL(string: "https://api.openweathermap.org/data/2.5/weather")!
    
    static func createWeatherInfoUrlFromCityID(_ id: String) -> URL {
        return Self.baseUrl.appendParameters(params: [QueryParameters.id: id,
                                                      QueryParameters.appid: Self.appID])!
    }
    
}

extension URL {
    
    func appendParameters( params: [String : String]) -> URL? {
        var components = URLComponents(string: self.absoluteString)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
        return components?.url
    }
    
}


class WeatherAPIHelper: NSObject {

    static let shared = WeatherAPIHelper()
    
    typealias WeatherInformationCompletionHandler = (CityWeatherModel?, AFError?) -> Void
    
    func getWeatherInformationForCityID(_ id: String, completion: @escaping WeatherInformationCompletionHandler) {
        AF.request(OpenWeatherAPIEndPoint.createWeatherInfoUrlFromCityID(id)).responseJSON { (response) in
            switch response.result {
            case .success(let responseData):
                let decoder = JSONDecoder()
                if let data = self.jsonToData(json: responseData) {
                    do {
                        let weatherInfo = try decoder.decode(CityWeatherModel.self, from: data)
                        completion(weatherInfo, nil)
                    }  catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                    
                    print("Data Converted:")
                }else {
                    completion(nil, nil)
                }
                print(responseData)
            case .failure(let error):
                completion(nil, error)
                print(error.localizedDescription)
            }
        }
    }
    
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    
}





