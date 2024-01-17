//
//  ContentView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            MapMarkerView()
                .tabItem { Text("임시 맵 마킹 표시") }
  
            PathRecordView()
                .tabItem { Text("임시 경로나타내기") }
        }

    } // body
}


#Preview {
    ContentView()
}
