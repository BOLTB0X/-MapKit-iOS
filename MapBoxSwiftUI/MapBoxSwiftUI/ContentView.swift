//
//  ContentView.swift
//  MapBoxSwiftUI
//
//  Created by lkh on 1/13/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct MarkPoints: Identifiable {
    let id = UUID()
    let pos: CLLocationCoordinate2D
    let imgString: String
    
    init(pos: CLLocationCoordinate2D, imgString: String) {
        self.pos = pos
        self.imgString = imgString
    }
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var viewport: Viewport = .styleDefault
    @State var markPointsArr : [MarkPoints] = [
        MarkPoints(pos: CLLocationCoordinate2D(latitude: 37.627647, longitude: 127.069929), imgString: "house"),
        MarkPoints(pos: CLLocationCoordinate2D(latitude: 37.625773, longitude: 127.072940), imgString: "lightbulb.fill"),
        MarkPoints(pos: CLLocationCoordinate2D(latitude: 37.631905, longitude: 127.077548), imgString: "graduationcap.fill")]
    
    let apart = CLLocationCoordinate2D(latitude: 37.627647, longitude: 127.069929)
    let gongneung = CLLocationCoordinate2D(latitude: 37.625773, longitude: 127.072940)
    let UniversityofTechn = CLLocationCoordinate2D(latitude: 37.631905, longitude: 127.077548)
    
    let polygon = Polygon(center: CLLocationCoordinate2D(latitude: 37.625773, longitude: 127.072940), radius: 1000, vertices: 5)
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Map(viewport: $viewport) {
                // 내 위치
                Puck2D(bearing: .heading)
                    .showsAccuracyRing(true)
                
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
                
                MapViewAnnotation(layerId: "route") {
                    Text("55 min")
                }
                
                // Polygon 추가
                PolygonAnnotation(polygon: polygon)
                    .fillColor(StyleColor(.systemGreen))
                    .fillOpacity(0.5)
                    .onTapGesture {
                        print("Polygon is tapped")
                    }
                    .onLongPressGesture {
                        print("Polygon is long-pressed")
                    }
            } // Map
            
            .mapStyle(.standard(lightPreset: colorScheme == .light ? .day : .dusk))
            .ignoresSafeArea()
            
            HStack(alignment: .center, spacing: 0) {
                Button("Overview route") {
                    // LineString 위치로 카메라 이동
                    withViewportAnimation(.easeIn(duration: 1)) {
                        viewport = .overview(geometry: LineString([apart, gongneung]))
                    }
                }
                Spacer()
                Button("Locate the user") {
                    // viewport 위치 업데이트
                    withViewportAnimation {
                        viewport = .followPuck(zoom: 20, pitch: 20)
                    }
                }
            } // HStack
            .padding(.horizontal)
        } // VStack
        .onAppear {
            viewport = .camera(center: apart, zoom: 14, bearing: 0, pitch: 0)
        }
    } // body
}

#Preview {
    ContentView()
}
