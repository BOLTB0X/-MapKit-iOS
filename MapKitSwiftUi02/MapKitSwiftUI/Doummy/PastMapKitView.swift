//
//  PastMapKitView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/15/24.
//

import SwiftUI
import MapKit

struct PastMapKitView: View {
    @State private var region: MKCoordinateRegion = MKCoordinateRegion()
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .onAppear {
                let manager = CLLocationManager()
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.requestWhenInUseAuthorization()
                
                let latitude = manager.location?.coordinate.latitude
                let longitude = manager.location?.coordinate.longitude
                
                region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!),
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            }
    }
}

//#Preview {
//    PastMapKitView()
//}
