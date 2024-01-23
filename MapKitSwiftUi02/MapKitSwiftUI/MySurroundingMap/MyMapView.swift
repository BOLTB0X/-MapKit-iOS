//
//  MyMap.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/19/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MyMapView: UIViewRepresentable {
    var viewModel: MyMapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = viewModel.mapView
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays) 
        
        let polyline = MKPolyline(coordinates: viewModel.markingPlace, count: viewModel.markingPlace.count)
        uiView.addOverlay(polyline)
    }
    
    func makeCoordinator() -> MyCoordinator {
        MyCoordinator(viewModel: viewModel)
    }
    
    class MyCoordinator: NSObject, MKMapViewDelegate {
        var viewModel: MyMapViewModel
        
        init(viewModel: MyMapViewModel) {
            self.viewModel = viewModel
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer()
            }
            
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3.0
            renderer.alpha = 1.0
            
            return renderer
        }
    }
}
