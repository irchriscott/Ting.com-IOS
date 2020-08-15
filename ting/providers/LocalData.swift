//
//  LocalData.swift
//  ting
//
//  Created by Christian Scott on 11/08/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class LocalData: NSObject {
    
    static let instance = LocalData()
    
    private let CUISINES_KEY = "cuisines"
    private let FILTERS_KEY = "filters"
    private let FILTER_PARAMS_KEY = "filter_params"
    
    public func saveCuisines(data: Data){
        UserDefaults.standard.set(data, forKey: CUISINES_KEY)
    }
    
    public func getCuisines() -> [RestaurantCategory] {
        let data = UserDefaults.standard.data(forKey: CUISINES_KEY)
        if let d = data {
            do { return try JSONDecoder().decode([RestaurantCategory].self, from: d) } catch { return [] }
        }
        return []
    }
    
    public func saveFilters(data: Data){
        UserDefaults.standard.set(data, forKey: FILTERS_KEY)
    }
    
    public func getFilters() -> RestaurantFilters? {
        let data = UserDefaults.standard.data(forKey: FILTERS_KEY)
        if let d = data {
            do { return try JSONDecoder().decode(RestaurantFilters.self, from: d) } catch { return nil }
        }
        return nil
    }
    
    public func saveFiltersParams(data: Data) {
        UserDefaults.standard.set(data, forKey: FILTER_PARAMS_KEY)
    }
    
    public func getFiltersParams() -> FiltersParameters {
        let data = UserDefaults.standard.data(forKey: FILTER_PARAMS_KEY)
        if let d = data {
            do { return try JSONDecoder().decode(FiltersParameters.self, from: d) } catch { return FiltersParameters(availability: [], cuisines: [], services: [], specials: [], types: [], ratings: []) }
        }
        return FiltersParameters(availability: [], cuisines: [], services: [], specials: [], types: [], ratings: [])
    }
    
    public func resetFiltersParams()  {
        let filters = FiltersParameters(availability: [], cuisines: [], services: [], specials: [], types: [], ratings: [])
        do {
            let data = try JSONEncoder().encode(filters)
            self.saveFiltersParams(data: data)
        } catch { return }
    }
}
