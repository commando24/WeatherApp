//
//  CityStore.swift
//  WeatherApp
//
//  Created by Surjeet Rajput on 24/02/21.
//

import UIKit

class CityStore {

    struct UserDefaultsConstant {
        static let favouriteCitiesArray = "FavouriteCitiesArray"
    }
    
    static let shared = CityStore()
    
    init() {
        self.cities = LocalFileHelper.shared.getCitiesFromLocalFiles()
        //get array from user defaults.
        if let idsArray = self.getFavouritesCitiesIDArrayFromUserDefaults() {
            self.favourites = self.cities.filter({ idsArray.contains($0.id) })
        }
    }
    
    var cities = [CityInfoModel]()
    var favourites = [CityInfoModel]()
    
    func addCityInFavourites(_ city: CityInfoModel) {
        //Add in local array.
        favourites.append(city)
        let citiesID = favourites.compactMap({ $0.id })
        //Save in user defaults.
        UserDefaults.standard.setValue(citiesID, forKey: UserDefaultsConstant.favouriteCitiesArray)
        //Synchronize
        UserDefaults.standard.synchronize()
    }
    
    func removeCityFromFavourites(_ city: CityInfoModel) {
        //Add in local array.
        guard let index = favourites.firstIndex(of: city) else {
            return
        }
        //Remove from array.
        favourites.remove(at: index)
        //Updated in user defaults.
        let citiesID = favourites.compactMap({ $0.id })
        //Save in user defaults.
        UserDefaults.standard.setValue(citiesID, forKey: UserDefaultsConstant.favouriteCitiesArray)
        //Synchronize
        UserDefaults.standard.synchronize()
    }
    
    func getFavouritesCitiesIDArrayFromUserDefaults() -> [Int64]? {
        return UserDefaults.standard.array(forKey: UserDefaultsConstant.favouriteCitiesArray) as? [Int64]
    }
    
    func filterCitiesFromText(_ text: String) -> [CityInfoModel] {
        guard !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return self.cities
        }
        var result = [CityInfoModel]()
        //Search using start with.
        result.append(contentsOf: self.cities.filter({ return $0.name.lowercased().starts(with: text.lowercased()) }))
        //using contains.
        result.append(contentsOf: self.cities.filter({ return $0.name.lowercased().contains(text.lowercased()) }))
        //Making set to remove duplicacy
        return Array(Set(result))
    }
    
    
}
