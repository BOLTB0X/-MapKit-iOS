//
//  UserMoveTraceViewModel.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/15/24.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - UserMoveTraceViewModel
class UserMoveTraceViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: 프로퍼티s
    @Published var userLocations: [CLLocationCoordinate2D] = [] // 경로
    
    @Published var currentLatitude: CLLocationDegrees = 0.0
    @Published var currentLongitude: CLLocationDegrees = 0.0
    
    @Published var currentAddress: String? // 주소
    
    @Published var isRecording: Bool = false // 기록
     
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - init
    override init() {
        super.init()
        getLocationUsagePermission()
    }
    
    // MARK: - Methods
    // MARK: - locationManager
    // ..
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            startUpdatingLocation()
        case .restricted, .notDetermined:
            print("GPS 권한 설정되지 않음")
            getLocationUsagePermission()
        case .denied:
            print("GPS 권한 요청 거부됨")
            getLocationUsagePermission()
        default:
            print("GPS: Default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        convertLocationToAddress(location: location)
        
        if isRecording && (userLocations.last?.latitude != location.coordinate.latitude ||
            userLocations.last?.longitude != location.coordinate.longitude) {
            userLocations.append(location.coordinate)
        }
    }
    
    
    // MARK: - CLLocationManagerDelegate 관련
    // ...
    // MARK: - getLocationUsagePermission
    func getLocationUsagePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - startUpdatingLocation
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - startUpdatingLocation
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
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
