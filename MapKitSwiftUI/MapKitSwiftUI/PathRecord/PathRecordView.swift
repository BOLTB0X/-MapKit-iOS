//
//  PathRecordView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/17/24.
//

import SwiftUI

// MARK: - PathRecordView
struct PathRecordView: View {
    @StateObject private var viewModel = UserMoveTraceViewModel()
    
    var body: some View {
        VStack(alignment: .center, spacing: 0)  {
            PathMapView(userLocations: viewModel.userLocations, isRecording: viewModel.isRecording)
                .onAppear {
                    viewModel.startUpdatingLocation()
                }
                .onDisappear {
                    viewModel.stopUpdatingLocation()
                }
                .ignoresSafeArea()
            
            HStack(alignment: .center, spacing: 0) {
                Button("기록") {
                    viewModel.isRecording.toggle()
                }
                .buttonStyle(.borderedProminent)
                Spacer()

                Text("Lat: \(viewModel.currentLatitude)")
                Spacer()
                
                Text("\(viewModel.currentAddress ?? "")")
                
                Spacer()
                Text("Long: \(viewModel.currentLongitude)")
            }
            .padding(.horizontal)
        } // VStack
        .onAppear {
            viewModel.getLocationUsagePermission()
        } // onAppear
    } // body
}

//#Preview {
//    PathRecordView()
//}
