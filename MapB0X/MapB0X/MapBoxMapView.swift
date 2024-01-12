//
//  MapB0XMapView.swift
//  MapB0X
//
//  Created by lkh on 1/11/24.
//

import SwiftUI
import UIKit
import MapboxMaps
import CoreLocation

// MARK: - MapBoxMapView
// UIViewControllerRepresentable 프로토콜로 UIKit 요소를 래핑하여 나타낼 호스팅 뷰
struct MapBoxMapView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: MapViewModel
    
    func makeUIViewController(context: Context) -> MapViewController {
        let mapViewController = MapViewController()
        mapViewController.viewModel = viewModel        
        return mapViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
}


