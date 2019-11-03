//
//  PolylineMapRoute.swift
//  ting
//
//  Created by Christian Scott on 21/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

struct Duration : Codable {
    let text: String
    let value: Int
}

struct Distance : Codable {
    let text: String
    let value: Int
}

struct OverviewPolyline : Codable {
    let points: String
}

struct Leg : Codable {
    let duration: Duration
    let distance: Distance
}

struct Route : Codable {
    let legs: [Leg]
    let overview_polyline: OverviewPolyline
}

struct PolylineMapRoute : Codable {
    let routes: [Route]
}
