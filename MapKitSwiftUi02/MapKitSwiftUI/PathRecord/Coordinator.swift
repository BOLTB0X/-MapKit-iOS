//
//  CoordinatorManager.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/15/24.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - Coordinator
class Coordinator: NSObject, MKMapViewDelegate {
    var mkView: PathMapView
    
    init(_ mkView: PathMapView) {
        self.mkView = mkView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .green
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        
        return renderer
    }
}
