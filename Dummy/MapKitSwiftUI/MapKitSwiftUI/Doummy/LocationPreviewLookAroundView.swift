//
//  LocationPreviewLookAroundView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI
import MapKit

// MARK: - LocationPreviewLookAroundView
struct LocationPreviewLookAroundView: View {
    @State private var lookAroundScene: MKLookAroundScene?
    var selectedResult: MyLocation
    
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult.title)")
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(18)
            }
            .onAppear {
                getLookAroundScene()
            }
            .onChange(of: selectedResult) {
                getLookAroundScene()
            }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            let request = MKLookAroundSceneRequest(coordinate: selectedResult.coordinate)
            lookAroundScene = try? await request.scene
        }
    }
}

//#Preview {
//    LocationPreviewLookAroundView(selectedResult: MyLocation(title: "공릉", coordinate: .gongneungStation))
//}
