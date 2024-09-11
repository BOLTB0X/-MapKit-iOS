//
//  RouteExView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/17/24.
//

import SwiftUI
import MapKit

struct RouteExView: View {
    @State private var selectedResult: MKMapItem?
    @State private var route: MKRoute?
    
    private let startingPoint = CLLocationCoordinate2D(
        latitude: 37.560828, longitude: 126.970839
    )
    
    private let destinationCoordinates = CLLocationCoordinate2D(
        latitude: 37.567179, longitude: 126.973263
    )
    
    var body: some View {
        Map(selection: $selectedResult) {
            // 마커 추가
            Marker("Start", coordinate: self.startingPoint)
            Marker("End", coordinate: self.destinationCoordinates)
            
            // 경로를 표시
            if let route {
                MapPolyline(route)
                    .stroke(.blue, lineWidth: 5)
            }
        }
        .onChange(of: selectedResult){
            // option + click 하면 도움말이 표시
            getDirections()
        }
        .onAppear {
            self.selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: self.destinationCoordinates))
        }
    }
    
    // 도움말 주석
    /**
     경로를 찾는 메서드
     */
    func getDirections() {
        self.route = nil
        
        // 선택한 결과가 있는지 확인
        guard selectedResult != nil else { return }
        
        // 길찾기 요청 개체 생성 및 구성
        let request = MKDirections.Request()
        request.transportType = .walking
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.startingPoint))
        request.destination = self.selectedResult
        
        // 요청에 따라 길찾기
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    RouteExView()
}
