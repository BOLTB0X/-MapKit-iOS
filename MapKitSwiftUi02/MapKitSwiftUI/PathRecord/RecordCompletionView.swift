//
//  RecordCompletionView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/22/24.
//

import SwiftUI

struct RecordCompletionView: View {
    // MARK: Object
    @EnvironmentObject var viewModel: PathRecordViewModel
    
    @EnvironmentObject var dbManager: RecordStore
    
    // MARK: - State
    @State private var titleText: String = ""
    @FocusState private var focusState: Bool
    
    // MARK: - Binding
    @Binding var isBack:Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 0) {
                PathMapView(
                    userLocations: viewModel.userLocations,
                    isRecording: viewModel.isRecording,
                    timerState: viewModel.timerState
                )
                .frame(height: 200)
                
                Divider()
                    .padding()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("날짜: \(getCurrentDateTime())")
                        .padding()
                    
                    TextField("", text: $titleText)
                        .focused($focusState)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                }
                .padding()
                
                HStack(alignment: .center, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("산책거리")
                        Text(viewModel.recordingMeter)
                            .bold()
                        //.foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("시간")
                        Text(viewModel.recordingTime.asTimestamp)
                            .bold()
                        //.foregroundColor(.black)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button("저장") {
                    let ret = viewModel.createRecordModel(title: titleText)
                    dbManager.addRecord(item: ret)
                    viewModel.timerState = .clear
                    viewModel.isRecording.toggle()
                    isBack.toggle()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
            }
            .onTapGesture {
                focusState = true
            }
        }
        .onAppear {
            self.dbManager.startListening()
            
        }
        
        .onDisappear {
            self.dbManager.stopListening()
            
        }
        
        .toolbar {
            // Leading
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(alignment: .center, spacing: 0) {
                    Button(action: {
                        isBack.toggle()
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundColor(.secondary)
                    })
                    
                    Spacer()
                } // HStack
                .padding(.horizontal)
            } // ToolbarItem
        } // toolbar
    } // body
    
    func getCurrentDateTime() -> String {
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: currentDate)
        
        return dateString
    }
}

//#Preview {
//    RecordCompletionView()
//}
