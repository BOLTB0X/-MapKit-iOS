//
//  MyMapViewModel.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/19/24.
//

import Foundation
import MapKit
import CoreLocation

class MyMapViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var mapView: MKMapView = .init()
    @Published var markingPlace: [CLLocationCoordinate2D] = []
    @Published var currentAddress: String = ""
    @Published var isChanging: Bool = false // 테스트용
    @Published var currentPos: CLLocationCoordinate2D? // 현재 위치
    @Published var currentLatitude: CLLocationDegrees = 0.0
    @Published var currentLongitude: CLLocationDegrees = 0.0

    private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        return manager
    }()
    
    override init() {
        super.init()
        
        requestLocationManager()
        mapViewFocusChange()
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        mapView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let locationInView = gesture.location(in: mapView)
        let tappedCoordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

        if let lastAnnotation = mapView.annotations.last {
            addPolyline(from: lastAnnotation.coordinate, to: tappedCoordinate)
        }

        addAnnotation(at: tappedCoordinate)
    }

    private func addAnnotation(at coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    private func addPolyline(from sourceCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) {
        let polyline = MKPolyline(coordinates: [sourceCoordinate, destinationCoordinate], count: 2)
        mapView.addOverlay(polyline)
    }

    // MARK: - requestLocationManager
    // 사용자 위치 권한 관련
    func requestLocationManager() {
        mapView.delegate = self
        manager.delegate = self
        
        let stauts = manager.authorizationStatus
        
        if stauts == .notDetermined { // 권한 요청 거질시
            manager.requestAlwaysAuthorization()
        } else if stauts == .authorizedAlways || stauts == .authorizedWhenInUse {
            mapView.showsUserLocation = false
        }
    }
    
    // MARK: - mapViewDidChangeVisibleRegion
    // 화면 이동될 시 이 메소드가 호출
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        DispatchQueue.main.async {
            self.isChanging = true
        }
    }
    
    // MARK: - mapView
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        // 현재 내 맵뷰에서 중심이 되는 CLLocation
        let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        self.convertLocationToAddress(location: location)
        //self.convertLo
        DispatchQueue.main.async {
            self.isChanging = false
        }
    }
    
    func testMapViewFocusChange() {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: .gongneungStation, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - mapViewFocusChange
    // 맵뷰 포커스 변경시 이용
    func mapViewFocusChange() {
        let span = MKCoordinateSpan(latitudeDelta: 0.0005, longitudeDelta: 0.0005)
        let region = MKCoordinateRegion(center: self.currentPos ?? .gongneungStation, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - locationManagerDidChangeAuthorization
    // 사용자에게 위치 권한이 변경되면 호출
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            guard let location = manager.location else {
                print("location Error")
                return
            }
            
            self.currentPos = location.coordinate // 현재 위치 저장
            self.mapViewFocusChange() // 저장한 위치로 이동
            self.convertLocationToAddress(location: location)
        }
    }
    
    // MARK: - locationManager
    

    // 현재 위치 불러오는 게 실패시 호출
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    // MARK: - convertLocationToAddress
    // 주소 변환
    func convertLocationToAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { marks, err in
            if err != nil { return }
            
            guard let marks = marks?.first else { return }
            
            self.currentAddress = "\(marks.country ?? "") \(marks.locality ?? "") \(marks.name ?? "")"
        }
        
        return
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
