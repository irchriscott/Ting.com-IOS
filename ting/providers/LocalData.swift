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
        UserDefaults.standard.set(data, forKey: CUISINES_KEY)
    }
    
    public func getFilters() -> RestaurantFilters? {
        let data = UserDefaults.standard.data(forKey: FILTERS_KEY)
        if let d = data {
            do { return try JSONDecoder().decode(RestaurantFilters.self, from: d) } catch { return nil }
        }
        return nil
    }
}
