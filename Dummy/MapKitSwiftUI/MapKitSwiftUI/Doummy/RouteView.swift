//
//  RouteView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI
import MapKit

// MARK: - RouteView
struct RouteView: View {
    @State private var route: MKRoute?
    @State private var travelTime: String?
    
    private let gradient = LinearGradient(colors: [.red, .orange], startPoint: .leading, endPoint: .trailing)
    private let stroke = StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [5, 5])
    
    var body: some View {
        Map {
            
            Marker("경춘선철교", coordinate: .tmpRoadStartPoints)
                .tint(.blue)
            
            if let route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 8)
            }
            
            Marker("경춘선숲", coordinate: .tmpRoadEndPoints)
                .tint(.blue)
        }
        .overlay(alignment: .bottom, content: {
             HStack {
                 if let travelTime {
                     Text("Travel time: \(travelTime)")
                         .padding()
                         .font(.headline)
                         .foregroundStyle(.black)
                         .background(.ultraThinMaterial)
                         .cornerRadius(15)
                 }
             }
         })
         .onAppear(perform: {
             fetchRouteFrom(.tmpRoadStartPoints, to: .tmpRoadEndPoints)
         })
    } // body
}

extension RouteView {
    // MARK: - fetchRouteFrom
    private func fetchRouteFrom(_ source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            getTravelTime()
        }
    }
    
    // MARK: - getTravelTime
    private func getTravelTime() {
        guard let route else { return }
        
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        travelTime = formatter.string(from: route.expectedTravelTime)
    }
}

#Preview {
    RouteView()
}
