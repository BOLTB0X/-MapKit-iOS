//
//  MapMarkerViewModel.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/18/24.
//

import Foundation
import MapKit
import CoreLocation
import Combine

struct TmpRecomm: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let image: String
    var Address: String
    var dist:String
    var time: String
    let coordinate: [CLLocationCoordinate2D]
    
    init() {
        self.title = ""
        self.image = ""
        self.Address = ""
        self.dist = ""
        self.time = ""
        self.coordinate = []
    }
    
    init(title: String, image: String, Address: String, dist:String, time: String, coordinate: [CLLocationCoordinate2D]) {
        self.title = title
        self.image = image
        self.Address = Address
        self.dist = dist
        self.time = time
        self.coordinate = coordinate
    }
    
    static func == (lhs: TmpRecomm, rhs: TmpRecomm) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - SurroundingMapViewModel
class SurroundingMapViewModel: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {
    @Published var mapView: MKMapView = .init() // MapView
    @Published var routes: [MKRoute] = []
    
    @Published var selectedRecomm: TmpRecomm = TmpRecomm()
    @Published var tmpRecomm: [TmpRecomm] = []
    
    @Published var currentLatitude: CLLocationDegrees = 0.0
    @Published var currentLongitude: CLLocationDegrees = 0.0
    
    // MARK: Object
    @Published var dbManager: RecordStore = RecordStore.shared
    
    private var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        return manager
    }()
    
    private var currentPos: CLLocationCoordinate2D? // 현재 위치
    private var cancellables: Set<AnyCancellable> = []
    
    
    override init() {
        super.init()
        
        requsetRecomm()
        
        RecordStore.shared.$records
            .sink { [weak self] records in
                self?.addFromDB(records: records)
            }
            .store(in: &cancellables)
        
        self.requestLocationManager()
    }
    
    // MARK: - requsetRecomm
    // 임시
    func requsetRecomm() {
        // 임시
        tmpRecomm = [
            TmpRecomm(title: "공리단길", image: "", Address: "서울특별시 하계동", dist: "2Km",time: "1h", coordinate: [.tmpRoadStartPoints, .tmpRoadEndPoints, .gongneungStation, .tmpRoadStartPoints]),
            
            TmpRecomm(title: "공릉동 길1", image: "", Address: "서울특별시 공릉동", dist: "800m", time: "20m", coordinate: [ .samsungServiceCenter,  .hahaha, .universityofTechn]),
            
            TmpRecomm(title: "공릉동 길2", image: "", Address: "서울특별시 공릉동", dist: "800m", time: "20m", coordinate: [.starbucks, .wpart])
        ]
        
        //addFromDB(records: dbManager.records)
    }
    
    // MARK: - addFromDB
    func addFromDB(records: [Record]) {
        print("addFromDB")
        for record in records {
            let ele = convertToTmpRecomm(record: record)
            print(ele)
            tmpRecomm.append(ele)
        }
        //print(tmpRecomm)
        
        return
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
        
        requsetRecomm()
        return
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
        }
    }
    
    // MARK: - mapViewFocusChange
    // 맵뷰 포커스 변경시 이용
    func mapViewFocusChange() {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: self.currentPos ?? .gongneungStation, span: span)
        
        mapView.setRegion(region, animated: true)
        return
    }
    
    
    // MARK: - findPathHaveId
    func findPathHaveId(id: UUID) {
        if let arr = tmpRecomm.first(where: { $0.id == id }) {
            selectedRecomm = arr
            
            // 임시
            convertLocationToAddress(location: CLLocation(latitude: arr.coordinate.first!.latitude, longitude: arr.coordinate.first!.longitude))
            
            Task {
                await fetchRoutes(from: arr.coordinate)
            }
        }
        
        
        
        return
    }
    
    // MARK: - fetchRoutes
    private func fetchRoutes(from coordinates: [CLLocationCoordinate2D]) async {
        guard coordinates.count >= 2 else { return }
        
        var allRoutes: [MKRoute] = []
        
        for i in 0..<(coordinates.count - 1) {
            let sourceCoordinate = coordinates[i]
            let destinationCoordinate = coordinates[i + 1]
            
            if let route = await fetchRouteFrom(sourceCoordinate, to: destinationCoordinate) {
                allRoutes.append(route)
            }
        }
        
        
        
        drawAllRoutes(allRoutes)
        return
    }
    
    // MARK: - fetchRouteFrom
    private func fetchRouteFrom(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) async -> MKRoute? {
        
        let route = MKRoute()
        
        let overlay = MKPolyline(coordinates: [source, destination], count: 2)
        
        route.setValue(overlay, forKey: "polyline")
        
        return route
        //        let request = MKDirections.Request()
        //        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        //        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        //        request.transportType = .walking
        //
        //        do {
        //            let result = try await MKDirections(request: request)
        //                .calculate()
        //            return result.routes.first
        //        } catch {
        //            print("fetchRouteFrom Error: \(error)")
        //            return nil
        //        }
    }
    
    // MARK: drawAllRoutes
    private func drawAllRoutes(_ paramRoutes: [MKRoute]) {
        var totalDist: CLLocationDistance = 0.0
        var totalTime: TimeInterval = 0.0
        
        mapView.removeOverlays(mapView.overlays)
        
        for route in paramRoutes {
            mapView.addOverlay(route.polyline)
            totalDist += route.distance
            totalTime += route.expectedTravelTime
        }
        
        routes = paramRoutes
        selectedRecomm.dist = "거리 \(String(format: "%.2f", totalDist))미터"
        selectedRecomm.time = getStringTime(totalTime: totalTime)
        
        return
    }
    
    private func convertToCLLocationCoordinate2D(locations: [Record.LocationCoordinate]) -> [CLLocationCoordinate2D] {
        return locations.map { $0.coordinate }
    }
    
    private func convertToTmpRecomm(record: Record) -> TmpRecomm {
        let coordinateArr = record.userLocations.map { convertToCLLocationCoordinate2D(locations: $0) } ?? []
        let ret = TmpRecomm(
            title: record.title,
            image: "",
            Address: record.currentAddress,
            dist: record.recordingMeter,
            time: record.recordingTime,
            coordinate: coordinateArr
        )
        
        return ret
    }
    
    // MARK: clearRoutes
    func clearRoutes() {
        mapView.removeOverlays(mapView.overlays)
        routes = []
        selectedRecomm.Address = ""
        selectedRecomm.dist = ""
        selectedRecomm.time = ""
    }
}


extension SurroundingMapViewModel {
    // MARK: - convertLocationToAddress
    // 주소 변환
    func convertLocationToAddress(location: CLLocation) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { marks, err in
            if err != nil { return }
            
            guard let marks = marks?.first else { return }
            
            self.selectedRecomm.Address = "\(marks.country ?? "") \(marks.locality ?? "") \(marks.name ?? "")"
        }
        
        return
    }
    
    // MARK: - getStringTime
    func getStringTime(totalTime: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute, .second]
        
        if let ret = formatter.string(from: totalTime) {
            return ret
        }
        return "XX:XX"
    }
}
