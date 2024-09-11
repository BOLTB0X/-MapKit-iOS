//
//  PathRecordView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/17/24.
//

import SwiftUI

// MARK: - PathRecordView
struct PathRecordView: View {
    // MARK: Environment
    @Environment(\.scenePhase) var scenePhase
    
    // MARK: Object
    @StateObject private var viewModel = PathRecordViewModel()
    
    // MARK: - View
    var body: some View {
        ZStack(alignment: .center)  {
            // MARK: Map
            PathMapView(userLocations: viewModel.userLocations, isRecording: viewModel.isRecording, timerState: viewModel.timerState)
                .onAppear { // 나타날 때
                    viewModel.startUpdatingLocation()
                    print("뷰 위치 업데이트 실행")
                }
            
                .onDisappear { // 사라질 때
                    viewModel.stopUpdatingLocation()
                    print("위치 업데이트 중지")
                }
                .ignoresSafeArea()
            
            // Test
                .onChange(of: scenePhase) { phase in
                    switch phase {
                    case .active:
                        print("Active")
                    case .inactive:
                        print("Inactive")
                    case .background:
                        print("Background")
                    default:
                        print("scenePhase err")
                    }
                }
            
            // Map 정보창
            PathRecodState(
                isRecording: $viewModel.isRecording,
                realTime: $viewModel.recordingTime,
                currentMeter: $viewModel.recordingMeter,
                timerState: $viewModel.timerState,
                startTimer: { viewModel.startTimer() },
                pauseTimer: { viewModel.pauseTimer() },
                cancleTimer: { viewModel.clearTimer() }
            )
        } // ZStack
        .onAppear {
            viewModel.getLocationUsagePermission()
        } // onAppear
    } // body
}

#Preview {
    PathRecordView()
}

