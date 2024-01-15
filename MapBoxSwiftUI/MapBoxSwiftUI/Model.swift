//
//  Model.swift
//  MapBoxSwiftUI
//
//  Created by lkh on 1/15/24.
//

import SwiftUI
import MapboxMaps
import CoreLocation
import MapboxCoreMaps

// MARK: - MarkPoints
struct MarkPoints: Identifiable {
    let id = UUID()
    let pos: CLLocationCoordinate2D
    let imgString: String
    
    init(pos: CLLocationCoordinate2D, imgString: String) {
        self.pos = pos
        self.imgString = imgString
    }
}

// MARK: CLLocationCoordinate2D
extension CLLocationCoordinate2D {
    static let apart = CLLocationCoordinate2D(latitude: 37.627647, longitude: 127.069929)
    
    static let gongneungStation = CLLocationCoordinate2D(latitude: 37.625797, longitude: 127.072940)
    
    static let starbucks = CLLocationCoordinate2D(latitude: 37.626423, longitude: 127.072252)
    
    static let samsungServiceCenter = CLLocationCoordinate2D(latitude: 37.627525, longitude: 127.072381)
    
    static let universityofTechn = CLLocationCoordinate2D(latitude: 37.631905, longitude: 127.077548)
    
    static let tmpRoadStartPoints = CLLocationCoordinate2D(latitude: 37.630804, longitude: 127.064472)
    
    static let tmpRoadEndPoints = CLLocationCoordinate2D(latitude: 37.620096, longitude: 127.081564)
}
