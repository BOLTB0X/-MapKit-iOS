//
//  GongneungView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - GongneungView
struct GongneungView: View {
    var body: some View {
        Map {
            Marker("공릉역", coordinate: .gongneungStation)
                .tint(.blue)
            
            Annotation("스타벅스 공릉점", coordinate: .starbucks) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                    Image(systemName: "cup.and.saucer.fill")
                        .padding(5)
                }
            }
            
            Annotation("삼성서비스 센터", coordinate: .samsungServiceCenter) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                    Image(systemName: "paperclip.circle")
                        .padding(5)
                }
            }
   
        } // Map
        //.mapStyle(.hybrid(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    } // body
}

// MARK: CLLocationCoordinate2D
extension CLLocationCoordinate2D {
    static let gongneungStation = CLLocationCoordinate2D(latitude: 37.625797, longitude: 127.072940)
    
    static let starbucks = CLLocationCoordinate2D(latitude: 37.626423, longitude: 127.072252)
    
    static let samsungServiceCenter = CLLocationCoordinate2D(latitude: 37.627525, longitude: 127.072381)
    
    static let universityofTechn = CLLocationCoordinate2D(latitude: 37.631905, longitude: 127.077548)
    
    
    static let tmpRoadStartPoints = CLLocationCoordinate2D(latitude: 37.630804, longitude: 127.064472)
    
    static let tmpRoadEndPoints = CLLocationCoordinate2D(latitude: 37.620096, longitude: 127.081564)
}

#Preview {
    GongneungView()
}
