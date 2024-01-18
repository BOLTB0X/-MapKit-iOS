//
//  PathRecodState.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/18/24.
//

import SwiftUI

// MARK: - PathRecodState
struct PathRecodState: View {
    // MARK: Binding
    @Binding var isRecording: Bool
    @Binding var realTime: Int
    @Binding var currentMeter: String
    @Binding var timerState: TimerState
    
    // MARK: Action
    var startTimer: (() -> Void)
    var pauseTimer: (() -> Void)
    var cancleTimer: (() -> Void)
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            
            RoundedRectangle(cornerRadius: 10)
                .padding([.bottom, .horizontal])           
                .frame(width: 350, height: 100)
                .foregroundColor(Color.white.opacity(0.8))
                .overlay(
                    VStack(alignment: .center, spacing: 0) {
                        HStack(alignment: .center, spacing: 10) {
                            Spacer()
                            Text("산책 시간 \(realTime.asTimestamp)")
                                .foregroundColor(.black)
                                .bold()
                            
                            Spacer()
                            
                            Text(currentMeter)
                                .foregroundColor(.black)
                                .bold()
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        stateRecordButton()
                        
                    }
                ) // overlay
        } // VStack
    } // body
    
    // MARK: - ViewBuilder
    // ..
    // MARK: - stateRecordButton
    @ViewBuilder
    private func stateRecordButton() -> some View {
        if isRecording {
            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    
                    if timerState == .pause {
                        timerState = .play
                    } else {
                        timerState = .pause
                    }
                    
                }, label: {
                    Image(systemName: timerState == .play ? "pause.circle" : "play.circle")
                })
                .foregroundColor(.blue)
                .padding()
                
                // TODO:
                Button("기록 저장") {
                    timerState = .clear
                    isRecording.toggle()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
            } // HStack
            .padding(.horizontal)
        } else {
            Button("기록 시작") {
                isRecording.toggle()
                timerState = .play
            }
            .buttonStyle(.borderedProminent)
            .padding()

        }
    }
}

extension Int {
    // MARK: - asTimestamp
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60
        
        if hour > 0 {
            return String(format: "%02i:%02i:%02i", hour, minute, second)
        } else {
            return String(format: "%02i:%02i", minute, second)
        }
    }
}

