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


#Preview {
    GongneungView()
}
