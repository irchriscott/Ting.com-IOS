//
//  PlacementProvider.swift
//  ting
//
//  Created by Christian Scott on 29/09/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class PlacementProvider: NSObject {
    
    private let PLACEMENT_SHARED_PREFERENCES_KEY    = "current_placement"
    private let PLACEMENT_TOKEN_PREFERENCES_KEY     = "current_placement_token"
    private let PLACEMENT_TEMP_TOKEN_SHARED_KEY     = "temp_placement_token"

    public func set(data: Data){
        UserDefaults.standard.set(data, forKey: PLACEMENT_SHARED_PREFERENCES_KEY)
    }

    public func setToken(data: String){
        UserDefaults.standard.set(data, forKey: PLACEMENT_TOKEN_PREFERENCES_KEY)
    }

    public func setTempToken(data: String){
        UserDefaults.standard.set(data, forKey: PLACEMENT_TEMP_TOKEN_SHARED_KEY)
    }

    public func get() -> Placement? {
        if self.isPlacedIn() {
            do {
                if let data = UserDefaults.standard.data(forKey: PLACEMENT_SHARED_PREFERENCES_KEY) {
                    return try JSONDecoder().decode(Placement.self, from: data)
                } else { return nil }
            } catch { return nil }
        } else { return nil }
    }

    public func getToken() -> String? {
        UserDefaults.standard.string(forKey: PLACEMENT_TOKEN_PREFERENCES_KEY)
    }

    public func getTempToken() -> String? {
        UserDefaults.standard.string(forKey: PLACEMENT_TEMP_TOKEN_SHARED_KEY)
    }

    public func isPlacedIn() -> Bool {
        return UserDefaults.standard.data(forKey: PLACEMENT_TOKEN_PREFERENCES_KEY) != nil || UserDefaults.standard.data(forKey: PLACEMENT_SHARED_PREFERENCES_KEY) != nil
    }
    
    public func placeOut() {
        UserDefaults.standard.removeObject(forKey: PLACEMENT_TEMP_TOKEN_SHARED_KEY)
        UserDefaults.standard.removeObject(forKey: PLACEMENT_TOKEN_PREFERENCES_KEY)
        UserDefaults.standard.removeObject(forKey: PLACEMENT_SHARED_PREFERENCES_KEY)
    }
}
