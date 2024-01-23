//
//  UserMoveTraceViewModel.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/15/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Combine

enum TimerState {
    case play
    case pause
    case clear
}

// MARK: - UserMoveTraceViewModel
class PathRecordViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // MARK: 프로퍼티s
    @Published var userLocations: [CLLocationCoordinate2D] = [] // 경로
    
    @Published var currentLatitude: CLLocationDegrees = 0.0
    @Published var currentLongitude: CLLocationDegrees = 0.0
    
    @Published var currentAddress: String? // 주소
    
    @Published var isRecording: Bool = false // 기록
    @Published var recordingTime: Int = 0
    @Published var recordingMeter: String = "현재 거리 0미터"
    
    @Published var timerState: TimerState = .clear {
        didSet {
            switch timerState {
            case .clear:
                clearTimer()
            case .pause:
                pauseTimer()
            case .play:
                startTimer()
            }
        }
    }
        
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10
        manager.startUpdatingLocation()
        manager.delegate = self
        return manager
    }()
    
    private var timerCancellable: Cancellable? // 타이머용
    
    // MARK: - init
    override init() {
        super.init()
        getLocationUsagePermission()
    }
    
    // MARK: - Methods
    // ...
    // MARK: - locationManager
    // 위치
    // ...
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS 권한 설정됨")
            startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
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
        print("위치 변경 감지, 위치 업데이트")
        currentLatitude = location.coordinate.latitude
        currentLongitude = location.coordinate.longitude
        
        convertLocationToAddress(location: location)
        
        //print(currentLatitude, currentLongitude)
        
        if timerState == .play {
            isPossibleRecord(location.coordinate)
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
    
    // MARK: - startTimer
    func startTimer() {
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.recordingTime += 1
                self.calculateTotalDist()
            }
    }
    
    // MARK: - pauseTimer
    func pauseTimer() {
        timerCancellable?.cancel()
    }
    
    
    func clearTimer() {
        timerCancellable?.cancel()
        recordingTime = 0
        userLocations = []
        recordingMeter = "현재 거리 0미터"
        isRecording = false
    }
    
    func createRecordModel(title: String) -> Record {
        let userLocat: [Record.LocationCoordinate] = userLocations.map { Record.LocationCoordinate(coordinate: $0) }
        
        return Record(userLocations: userLocat, title: title, currentAddress: currentAddress ?? "변환 X", recordingMeter: recordingMeter, recordingTime: recordingTime.asTimestamp)
    }
    
    // MARK: - isPossibleRecord
    // 기록할지 말지
    private func isPossibleRecord(_ location: CLLocationCoordinate2D) {
        if userLocations.isEmpty || distanceCoordinates(userLocations.last!, location) > 10.0 {
            userLocations.append(location)
        }
    }
    
    // MARK: - distanceCoordinates
    // 거리 계산
    private func distanceCoordinates(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
        
        return location1.distance(from: location2)
    }
    
    // MARK: - calculateTotalDist
    // 위치 경도로 거리계산
    // 들어온 순서로 차잇값을 구한 뒤 distance 이용
    private func calculateTotalDist() {
        var totalDistance: CLLocationDistance = 0.0
        
        if userLocations.count <= 1 { return }
        
        for i in 0..<(userLocations.count - 1) {
            let location1 = CLLocation(latitude: userLocations[i].latitude, longitude: userLocations[i].longitude)
            let location2 = CLLocation(latitude: userLocations[i + 1].latitude, longitude: userLocations[i + 1].longitude)
            
            totalDistance += location1.distance(from: location2)
        }
        
        recordingMeter = "이동 거리 \(String(format: "%.2f", totalDistance))미터"
    }
}
