//
//  ContentView.swift
//  MapBoxSwiftUI
//
//  Created by lkh on 1/13/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

// MARK: - ContentView
struct ContentView: View {
    // MARK: 프로퍼티s
    @Environment(\.colorScheme) var colorScheme
    @State var viewport: Viewport = .styleDefault
    @State var markPointsArr : [MarkPoints] = [
        MarkPoints(pos: .gongneungStation, imgString: "lightbulb.fill"),
        MarkPoints(pos: .samsungServiceCenter, imgString: "lightbulb.fill"),
        MarkPoints(pos: .starbucks, imgString: "lightbulb.fill"),
        MarkPoints(pos: .universityofTechn, imgString: "lightbulb.fill")
    ]
        
    let polygon = Polygon(center: CLLocationCoordinate2D(latitude: 37.625773, longitude: 127.072940), radius: 1000, vertices: 5)
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Map(viewport: $viewport) {
                // 내 위치
                Puck2D(bearing: .heading)
                    .showsAccuracyRing(false)
                
                // foreach
                ForEvery(markPointsArr) { arr in
                    MapViewAnnotation(coordinate: arr.pos) {
                        Image(systemName: arr.imgString)
                            .frame(width: 30, height: 30)
                            .background(Circle().fill(.blue))
                    }
                    .variableAnchors([
                        ViewAnnotationAnchorConfig(anchor: .bottom)
                    ])
                } // ForEvery
            } // Map
            
            .mapStyle(.standard(lightPreset: colorScheme == .light ? .day : .dusk))
            .ignoresSafeArea()
            
            HStack(alignment: .center, spacing: 0) {
                Button("Overview route") {
                    withViewportAnimation(.easeIn(duration: 1)) {
                        viewport = .overview(geometry: LineString([.tmpRoadStartPoints, .tmpRoadEndPoints]))
                    }
                }
                
                Spacer()
                
                Button("Record") {
                    
                }
                
                Spacer()
                
                Button("Locate the user") {
                    withViewportAnimation {  // viewport 위치 업데이트
                        viewport = .followPuck(zoom: 20, pitch: 20)
                    }
                }
            } // HStack
            .padding(.horizontal)
        } // VStack
        .onAppear {
            viewport = .followPuck(zoom: 17, pitch: 17)
        }
    } // body
}


#Preview {
    ContentView()
}
