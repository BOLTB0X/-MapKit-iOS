//
//  MapMarkerView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/17/24.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: MyLocation
// 임시 모델
struct MyLocation: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    
    static func == (lhs: MyLocation, rhs: MyLocation) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - MapMarkerView
struct MapMarkerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .automatic
    @State private var selection: UUID?
    
    let myLocationsArr = [
        MyLocation(title: "공릉", coordinate: .gongneungStation),
        MyLocation(title: "삼성서비스센터", coordinate: .samsungServiceCenter),
        MyLocation(title: "공릉스타벅스", coordinate: .starbucks),
        MyLocation(title: "서울과학기술대학교", coordinate: .universityofTechn)
    ]
    
    var body: some View {
        ZStack(alignment: .center) {
            Map(position: $position, selection: $selection) {
                ForEach(myLocationsArr) { location in
                    Marker(location.title, coordinate: location.coordinate)
                        .tint(.blue)
                }
            } // Map
            
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                HStack {
                    Button("내 위치") {
                        withAnimation {
                            position = .item(MKMapItem(placemark: .init(coordinate: CLLocationCoordinate2D(latitude: locationManager.currentLatitude, longitude: locationManager.currentLongitude))))
                        }
                    }.buttonStyle(.borderedProminent)
                    
                    Spacer()
                    Button("인근 산책로") {
                        withAnimation {
                            if let ele = myLocationsArr.first {
                                position = .item(MKMapItem(placemark: .init(coordinate: ele.coordinate)))
                            }
                        }
                    }.buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                if let selection {
                    if let item = myLocationsArr.first(where: { $0.id == selection }) {
                        
                        RoundedRectangle(cornerRadius: 10)
                            .padding([.bottom, .horizontal])                        .frame(width: 350, height: 150)
                            .foregroundColor(.white)
                            .overlay(
                                MapMarkerDetail(selectedResult: item)
                                    .frame(height: 128)
                            )
                    }
                } // if let item
            } // if let selection
        } // VStack
            
        .onChange(of: selection) {
            guard let selection else { return }
            guard let item = myLocationsArr.first(where: { $0.id == selection }) else { return }
            print(item.coordinate)
        } // onChange
        
        .onAppear {
            locationManager.requestLocationManager()
        }
    } // body
}

#Preview {
    MapMarkerView()
}
