//
//  LocationManager.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/15/24.
//

import Foundation
import MapKit
import CoreLocation

// MARK: - LocationManager
class LocationManager: NSObject, MKMapViewDelegate, ObservableObject, CLLocationManagerDelegate {
    // MARK: 프로퍼티s
    // ...
    @Published var mapView: MKMapView = .init() // MapView
    @Published var isRecord: Bool = false // 기록중인지 확인 용도
    @Published var isChanging: Bool = false // 테스트용
    @Published var currentAddress: String = "" // 현재 주소
    @Published var recordPos: [CLLocationCoordinate2D] = [] // 기록 좌표들
    @Published var currentLatitude: CLLocationDegrees = 0.0
    @Published var currentLongitude: CLLocationDegrees = 0.0
    
    @Published var region = MKCoordinateRegion( // 지역
        center: .gongneungStation,
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        return manager
    }()
    
    private var currentPos: CLLocationCoordinate2D? // 현재 위치
    
    override init() {
        super.init()
        
        self.requestLocationManager()
    }
    
    // MARK: - Methods
    // ...
    
    // MARK: - requestLocationManager
    // 사용자 위치 권한 관련
    func requestLocationManager() {
        mapView.delegate = self
        manager.delegate = self
        
        let stauts = manager.authorizationStatus
        
        if stauts == .notDetermined { // 권한 요청 거질시
            manager.requestAlwaysAuthorization()
        } else if stauts == .authorizedAlways || stauts == .authorizedWhenInUse {
            mapView.showsUserLocation = true
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
        
        //self.convertLo
        DispatchQueue.main.async {
            self.isChanging = false
        }
    }
    
    // MARK: - mapViewFocusChange
    // 맵뷰 포커스 변경시 이용
    func mapViewFocusChange() {
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
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
    
    // startUpdatingLocation or requestLocation 호출 했을 때 이용
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("위치 업데이트")
        
        guard let location = locations.last else { return }
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        region.center = location.coordinate
        region.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        if recordPos.last?.latitude != location.coordinate.latitude ||
            recordPos.last?.longitude != location.coordinate.longitude {
            
            recordPos.append(location.coordinate)
        }
    }
    
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
