//
//  ContentView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var dbManager = RecordStore.shared
    
    @State private var selection = 0
    
    var body: some View {
        TabView {
            SurroundingMapView()
                .tabItem { Text("임시 맵 마킹 표시") }
                .environmentObject(dbManager)
                .tag(0)

            PathRecordView()
                .tabItem { Text("임시 경로나타내기") }
                .tag(1)

        }
        
        .onAppear {
            self.dbManager.startListening()
            print(dbManager.records)
            
        }
        
        .onDisappear {
            self.dbManager.stopListening()
            
        }
    } // body
}


#Preview {
    ContentView()
}
