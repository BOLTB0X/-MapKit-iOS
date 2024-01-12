//
//  MapViewController.swift
//  MapB0X
//
//  Created by lkh on 1/11/24.


import UIKit
import MapboxMaps
import CoreLocation
import Combine

// MARK: - MapViewController
class MapViewController: UIViewController, CLLocationManagerDelegate {
    // MARK: 프로퍼티s
    var viewModel: MapViewModel!
    var mapView: MapView!
    //
    // 위치 ==> 현재 위치를 파악하고 지도에 표시하는 프로퍼티
    let locationManager = CLLocationManager()
    // 걸은 길
    
    // MARK: - Methods
    // ...
    // MARK: - viewDidLoad
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tokenKey = Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as? String else {
            print("token 키 에러")
            return
        }
        
        // 나타낼 Mapbox 맵의 기본 구성을 설정
        let myResourceOptions = ResourceOptions(accessToken: tokenKey)
        
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions, styleURI: StyleURI.streets)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        // CLLocationManager 초기화 및 위치 서비스 권한 요청
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        viewModel.$currentLocation
            .sink { [weak self] location in
                self?.updateMapView(with: location)
            }
            .store(in: &cancellables)
        
        viewModel.$followPuckViewportState
            .sink { [weak self] followPuckViewportState in
                self?.updateMapView(with: followPuckViewportState)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - updateMapView
    // ...
    
    private func updateMapView(with location: CLLocationCoordinate2D?) {
        // 맵을 현재 위치 기반으로
        mapView.location.overrideLocationProvider(with: AppleLocationProvider())
        
        // 내 위치 파란점 짝어주기
        mapView.location.options.puckType = .puck2D(Puck2DConfiguration.makeDefault(showBearing: true))
        
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState(
            options: FollowPuckViewportStateOptions(
                padding: UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0),
                bearing: .constant(0),
                pitch: 0.5))
        
        mapView.viewport.transition(to: followPuckViewportState) { success in
            //print("카메라 적용 성공")
        }

    }
    
    private func updateMapView(with followPuckViewportState: FollowPuckViewportState?) {
        // 맵을 현재 위치 기반으로
        mapView.location.overrideLocationProvider(with: AppleLocationProvider())
        
        // 내 위치 파란점 짝어주기
        mapView.location.options.puckType = .puck2D(Puck2DConfiguration.makeDefault(showBearing: true))
        
        let followPuckViewportState = mapView.viewport.makeFollowPuckViewportState(
            options: FollowPuckViewportStateOptions(
                padding: UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0),
                bearing: .constant(0),
                pitch: 0.5))
        
        mapView.viewport.transition(to: followPuckViewportState) { success in
            //print("카메라 적용 성공")
        }

    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - locationManager
    // ...
    // CLLocationManagerDelegate 구현
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Mapbox 지도에 현재 위치 표시
            let cameraOptions = CameraOptions(center: location.coordinate, zoom: 15)
            mapView.camera.ease(to: cameraOptions, duration: 1.0)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
