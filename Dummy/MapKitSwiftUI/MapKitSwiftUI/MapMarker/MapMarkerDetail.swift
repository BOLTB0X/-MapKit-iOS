//
//  MapMarkerDetail.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/17/24.
//

import SwiftUI

struct MapMarkerDetail: View {
    var selectedResult: MyLocation
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(selectedResult.title)
            
            HStack(alignment: .center, spacing: 0) {
                
                Text("\(selectedResult.coordinate.latitude)")
                
                Spacer()
                
                Text("\(selectedResult.coordinate.longitude)")
            }
        }
        .padding(18)
    }
}

//#Preview {
//    MapMarkerDetail()
//}
