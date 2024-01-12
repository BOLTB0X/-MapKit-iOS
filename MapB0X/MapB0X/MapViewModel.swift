//
//  MapViewModel.swift
//  MapB0X
//
//  Created by lkh on 1/12/24.


import Foundation
import Combine
import CoreLocation
import MapboxMaps

// 뷰 모델 정의
class MapViewModel: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var followPuckViewportState: FollowPuckViewportState?
    @Published var zoomPlus = 0.1
    @Published var zoomMinus = 0.1
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {}
}
