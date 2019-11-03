//
//  Functions.swift
//  ting
//
//  Created by Ir Christian Scott on 07/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit
import MapKit

class Functions : NSObject {
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    class func isConnectedToInternet() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress){
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){ zeroSocketAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSocketAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags){
            return false
        }
        
        let isReachable = flags.rawValue & UInt32(kSCNetworkFlagsReachable) != 0
        let needsConnection = flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired) != 0
        
        return isReachable && !needsConnection
    }
    
    static func statusWorkTime(open: String, close: String) -> [String: String]? {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let calendar = Calendar.current
        let calendarComponets: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let dateTimeComponents = calendar.dateComponents(calendarComponets, from: date)
        
        let todayDate = "\(dateTimeComponents.year!)-\(dateTimeComponents.month!)-\(dateTimeComponents.day!)"
        
        let _ = "\(todayDate) \(dateTimeComponents.hour!):\(dateTimeComponents.minute!)"
        let nowTime = date.toMillis()
        let openTime = dateFormatter.date(from: "\(todayDate) \(open)")!.toMillis()
        let closeTime = dateFormatter.date(from: "\(todayDate) \(close)")!.toMillis()
        
        if openTime >= nowTime {
            let time = (openTime - nowTime) / (1000 * 60)
            let add: Int64 = time >= 90 ? 1 : 0
            if time < 120 {
                let r = time >= 60 ? "\(((time - 1) / 60) + add) hr" : "\(time + 1) min"
                return ["clr": "orange", "msg": "Opening in \(r)", "st": "closed"]
            } else { return ["clr": "red", "msg": "Closed", "st": "closed"] }
        } else if nowTime > openTime {
            if nowTime > closeTime { return ["clr": "red", "msg": "Closed", "st": "closed"] }
            else {
                let time = (closeTime - nowTime) / (1000 * 60)
                let add: Int64 = time >= 90 ? 1 : 0
                if time < 120 {
                    let r = time >= 60 ? "\(((time - 1) / 60) + add) hr" : "\(time + 1) min"
                    return ["clr": "orange", "msg": "Closing in \(r)", "st": "opened"]
                } else { return ["clr": "green", "msg": "Opened", "st": "opened"] }
            }
        }
        return nil
    }
    
    static func frameForCircle(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    static func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static func googleMapsDirectornURL(origin: CLLocation, destination: CLLocation, mode: String) -> URL? {
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?key=\(StaticData.googleMapsKey)&origin=\(origin.coordinate.latitude),\(origin.coordinate.longitude)&destination=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&sensor=false&mode=\(mode)"
        return URL(string: urlString)
    }
}
