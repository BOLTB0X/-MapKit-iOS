//
//  MapMarkerAnotherView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/17/24.
//

import SwiftUI
import MapKit

struct MapMarkerAnotherView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var selection: UUID?

    let myLocationsArr = [
        MyLocation(title: "공릉", coordinate: .gongneungStation),
        MyLocation(title: "삼성서비스센터", coordinate: .samsungServiceCenter),
        MyLocation(title: "공릉스타벅스", coordinate: .starbucks),
        MyLocation(title: "서울과학기술대학교", coordinate: .universityofTechn)
    ]
    
    var body: some View {
        Map(position: $position, selection: $selection) {
            ForEach(myLocationsArr) { location in
                Marker(location.title, coordinate: location.coordinate)
                    .tint(.blue)
            }
        }
    }
}

#Preview {
    MapMarkerAnotherView()
}
