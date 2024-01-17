//
//  MapView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/15/24.
//

import SwiftUI
import MapKit

// MARK: - MapView
struct PathMapView: UIViewRepresentable {
    var userLocations: [CLLocationCoordinate2D]
    var isRecording: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        if isRecording && userLocations.count > 1 {
            let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
            uiView.addOverlay(polyline)
            
            let region = MKCoordinateRegion(center: userLocations.last!, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            uiView.setRegion(region, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
