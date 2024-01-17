//
//  LocationPreviewView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI
import MapKit

struct LocationPreviewView: View {
    @State private var selection: UUID?
    
    let myLocationsArr = [
        MyLocation(title: "공릉", coordinate: .gongneungStation),
        MyLocation(title: "삼성서비스센터", coordinate: .samsungServiceCenter),
        MyLocation(title: "공릉스타벅스", coordinate: .starbucks),
        MyLocation(title: "서울과학기술대학교", coordinate: .universityofTechn)
    ]
    
    var body: some View {
        Map(selection: $selection) {
            ForEach(myLocationsArr) { location in
                Marker(location.title, coordinate: location.coordinate)
                    .tint(.blue)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    if let selection {
                        if let item = myLocationsArr.first(where: { $0.id == selection }) {
                            LocationPreviewLookAroundView(selectedResult: item)
                                .frame(height: 128)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding([.top, .horizontal])
                        }
                    } // if let
                } // VStack
                Spacer()
            } // HStack
            .background(.thinMaterial)
        }
        .onChange(of: selection) {
            guard let selection else { return }
            guard let item = myLocationsArr.first(where: { $0.id == selection }) else { return }
            print(item.coordinate)
        } // onChange
    } // body
}

#Preview {
    LocationPreviewView()
}
