//
//  ContentView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dbManager = RecordStore.shared

    var body: some View {
        TabView {
            SurroundingMapView()
                .tabItem { Text("임시 맵 마킹 표시") }
  
            PathRecordView()
                .tabItem { Text("임시 경로나타내기") }
            
//            RecordListView()
//                .tabItem { Text("DB 확인용") }
        }
        .onAppear {
            self.dbManager.startListening()
            
        }
        
        .onDisappear {
            self.dbManager.stopListening()
            
        }
    } // body
}


#Preview {
    ContentView()
}
