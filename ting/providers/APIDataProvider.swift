//
//  APIDataProvider.swift
//  ting
//
//  Created by Christian Scott on 15/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import UIKit

class APIDataProvider: NSObject {
    
    static let instance = APIDataProvider()
    let session = UserAuthentication().get()!
    let appWindow = UIApplication.shared.keyWindow
    
    public func getRestaurants(url: String, completion: @escaping ([Branch]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let restaurants = try JSONDecoder().decode([Branch].self, from: data)
                    DispatchQueue.main.async { completion(restaurants) }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                        self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    public func getRestaurantMenus(url: String, completion: @escaping ([RestaurantMenu]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let menus = try JSONDecoder().decode([RestaurantMenu].self, from: data)
                    DispatchQueue.main.async { completion(menus) }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                        self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    public func getRestaurantMenu(url: String, completion: @escaping (RestaurantMenu?) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let menu = try JSONDecoder().decode(RestaurantMenu.self, from: data)
                    DispatchQueue.main.async { completion(menu) }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
                    }
                }
            }
        }.resume()
    }
    
    public func getMenuReviews(url: String, completion: @escaping ([MenuReview]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let reviews = try JSONDecoder().decode([MenuReview].self, from: data)
                    DispatchQueue.main.async { completion(reviews) }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                        self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    public func getRestaurantPromotions(url: String, completion: @escaping ([MenuPromotion]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let promotions = try JSONDecoder().decode([MenuPromotion].self, from: data)
                    DispatchQueue.main.async { completion(promotions) }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                        self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    public func getPromotionMenu(url: String, completion: @escaping (MenuPromotion?) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let promotion = try JSONDecoder().decode(MenuPromotion.self, from: data)
                    DispatchQueue.main.async { completion(promotion) }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil)
                        Toast.makeToast(message: error.localizedDescription, duration: Toast.MID_LENGTH_DURATION, style: .error)
                    }
                }
            }
        }.resume()
    }
    
    public func getRestaurantReviews(url: String, completion: @escaping ([RestaurantReview]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let reviews = try JSONDecoder().decode([RestaurantReview].self, from: data)
                    DispatchQueue.main.async { completion(reviews) }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                        self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    public func getRestaurantLikes(url: String, completion: @escaping ([UserRestaurant]) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(self.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                do {
                    let likes = try JSONDecoder().decode([UserRestaurant].self, from: data)
                    DispatchQueue.main.async { completion(likes) }
                } catch {
                    DispatchQueue.main.async {
                        completion([])
                        self.appWindow?.rootViewController?.showErrorMessage(message: error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
}
