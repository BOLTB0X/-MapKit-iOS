//
//  MySurroundingMapView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/19/24.
//

import SwiftUI
import MapKit

struct MySurroundingMapView: View {
    @StateObject private var viewModel = MyMapViewModel()
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            MyMapView(viewModel: viewModel)
            
            HStack {
                Button("공릉으로 이동") {
                    viewModel.testMapViewFocusChange()
                }
                
                Text(viewModel.currentAddress)
            }
        }
    }
}


#Preview {
    MySurroundingMapView()
}
