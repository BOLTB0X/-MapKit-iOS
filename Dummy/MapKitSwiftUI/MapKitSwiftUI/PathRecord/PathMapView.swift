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
    // MARK: - 프로퍼티s
    var userLocations: [CLLocationCoordinate2D]
    var isRecording: Bool
    var timerState: TimerState

    // MARK: - makeUIView
    // 뷰가 그려질 때 호출
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.isZoomEnabled = true
        mapView.delegate = context.coordinator
        return mapView
    }
    
    // MARK: - updateUIView
    // 변경 시 업데이트 뷰
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        if timerState != .clear && userLocations.count > 1 {
            let polyline = MKPolyline(coordinates: userLocations, count: userLocations.count)
            uiView.addOverlay(polyline)
            
            let region = MKCoordinateRegion(center: userLocations.last!, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            uiView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - makeCoordinator
    // 좌표상에 MKPolylineRenderer
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
