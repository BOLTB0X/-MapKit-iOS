//
//  CustomMapView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/16/24.
//

import SwiftUI
import MapKit

// MARK: - CustomMapView
struct CustomMapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        return locationManager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) { 
        uiView.removeOverlays(uiView.overlays)
        
        if locationManager.recordPos.count > 1 {
            let polyline = MKPolyline(coordinates: locationManager.recordPos, count: locationManager.recordPos.count)
            
            let region = MKCoordinateRegion(center: locationManager.recordPos.last!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
}
