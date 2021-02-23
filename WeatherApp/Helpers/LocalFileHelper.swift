//
//  LocalFileHelper.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 23/02/21.
//

import UIKit

class LocalFileHelper: NSObject {

    static let shared = LocalFileHelper()
    
    enum LocalFiles: String {
        case cities = "Cities"
        
        var type : String {
            switch  self {
            case .cities:
                return "json"
            }
        }
        
    }
    
    /// To Get Json from Local File
    /// - Parameter key: name of file in Bundle
    func getJsonFromLocalFile(_ file: LocalFiles) -> [[String: Any]]?{
        if let path = Bundle.main.path(forResource: file.rawValue, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                return jsonResult
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func getCitiesFromLocalFiles() -> [CityInfoModel] {
        guard let jsonArray = self.getJsonFromLocalFile(LocalFiles.cities) else {
            return []
        }
        return jsonArray.compactMap { CityInfoModel(fromJSON: $0) }
    }
    
}
