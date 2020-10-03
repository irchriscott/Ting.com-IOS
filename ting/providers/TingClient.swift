//
//  TingClient.swift
//  ting
//
//  Created by Christian Scott on 02/10/2020.
//  Copyright © 2020 Ir Christian Scott. All rights reserved.
//

import UIKit

class TingClient: NSObject {
    
    private static let session = UserAuthentication().get()!
    let appWindow = UIApplication.shared.keyWindow
    
    static func getRequest(url: String, completion: @escaping (Data?) -> ()){
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(TingClient.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(TingClient.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                DispatchQueue.main.async { completion(data) }
            }
        }.resume()
    }
    
    static func postRequest(url: String, params: Parameters, completion: @escaping (Data?) -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = Requests().generateBoundary()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(TingClient.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        request.setValue(TingClient.session.token!, forHTTPHeaderField: "AUTHORIZATION")
        
        let httpBody = Requests().createDataBody(withParameters: params, media: nil, boundary: boundary)
        request.httpBody = httpBody
        
        let session = URLSession.shared
        
        session.dataTask(with: request){ (data, response, error) in
            if response != nil {}
            if let data = data {
                DispatchQueue.main.async { completion(data) }
            }
        }.resume()
    }
}
