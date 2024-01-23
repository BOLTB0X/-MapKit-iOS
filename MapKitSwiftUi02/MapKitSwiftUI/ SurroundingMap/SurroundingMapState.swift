//
//  SurroundingMapState.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/19/24.
//

import SwiftUI
import MapKit

struct SurroundingMapState: View {
    // MARK: Binding
    @Binding var pathInfo: TmpRecomm
    //@Binding var route: MKRoute?
 
    // MARK: - View
    var body: some View {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .padding([.bottom, .horizontal])
                    .frame(width: 350, height: 150)
                    .foregroundColor(Color.white.opacity(0.8))
                    .overlay(
                        HStack(alignment: .center, spacing: 10) {
                            
                            Spacer()
                            
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 100, height: 100)
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(pathInfo.title)
                                    .foregroundColor(.black)
                                
                                Text(pathInfo.Address)
                                    .foregroundColor(.black)
                                
                                Text(pathInfo.time)
                                    .foregroundColor(.black)
                                
                                Text(pathInfo.dist)
                                    .foregroundColor(.black)
                            }
                            
                            Spacer()
                        }
                            .padding(.horizontal)
                    )
        }
    } // body
}

//#Preview {
//    SurroundingMapState()
//}
