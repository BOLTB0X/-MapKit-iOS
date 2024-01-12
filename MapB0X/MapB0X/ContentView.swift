//
//  ContentView.swift
//  MapB0X
//
//  Created by lkh on 1/11/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct ContentView: View {
    @ObservedObject var viewModel = MapViewModel.init()
    
    var body: some View {
        MapBoxMapView(viewModel: viewModel)
    } // body
}

#Preview {
    ContentView()
}
