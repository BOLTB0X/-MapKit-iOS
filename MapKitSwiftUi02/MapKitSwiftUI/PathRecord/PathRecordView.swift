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
    @ObservedObject var dbManager: RecordStore = RecordStore.shared
    @ObservedObject private var viewModel = PathRecordViewModel()
    
    // MARK: State
    @State private var showBottom: Bool = false
    @State private var isGoSaveView: Bool = false

    // MARK: - View
    var body: some View {
        NavigationStack {
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
                    showBottom: $showBottom,
                    realTime: $viewModel.recordingTime,
                    currentMeter: $viewModel.recordingMeter,
                    timerState: $viewModel.timerState,
                    startTimer: { viewModel.startTimer() },
                    pauseTimer: { viewModel.pauseTimer() },
                    cancleTimer: { viewModel.clearTimer() }
                )
            } // ZStack
            .navigationDestination(isPresented: $isGoSaveView) {
                RecordCompletionView(isBack: $isGoSaveView)
                    .environmentObject(viewModel)
                    .environmentObject(dbManager)
                    .navigationBarBackButtonHidden()
             }
        }
        
        // MARK:
        .sheet(isPresented: $showBottom) {
            VStack(alignment: .center, spacing: 0) {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    Text(viewModel.recordingTime.asTimestamp)
                        .bold()
                        //.foregroundColor(.black)
                    
                    Spacer()

                    Text(viewModel.recordingMeter)
                        .bold()
                        //.foregroundColor(.black)
                    
                    Spacer()
                }
                
                Spacer()
                
                Button("기록 저장하기") {
                    showBottom.toggle() // 바텀 뷰 내리고
                    isGoSaveView.toggle() // 저장 뷰로 이동
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
            }
            .presentationDetents([.height(200)])
        }
        
        .onAppear {
            viewModel.getLocationUsagePermission()
        } // onAppear
        
    } // body
}

#Preview {
    PathRecordView()
        .environmentObject(RecordStore.shared)
}

