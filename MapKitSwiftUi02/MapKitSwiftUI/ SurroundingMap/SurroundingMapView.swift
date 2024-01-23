//
//  SurroundingMapView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/18/24.
//

import SwiftUI
import MapKit

// MARK: - SurroundingMapView
struct SurroundingMapView: View {
    // MARK: Object
    @ObservedObject var dbManager: RecordStore = RecordStore.shared

    @ObservedObject private var viewModel = SurroundingMapViewModel()
    
    // MARK: State
    @State private var position: MapCameraPosition = .automatic
    @State private var selection: UUID?
    
    // MARK: - View
    var body: some View {
        ZStack(alignment: .center) {
            Text("~~")
            // MARK: Map
            Map(position: $position, selection: $selection) {
                ForEach(viewModel.tmpRecomm) { location in
                    Marker(location.title, coordinate: location.coordinate.first!)
                        .tint(.blue)
                }
                
                ForEach(dbManager.records) { rec in
                    if let loc = rec.userLocations {
                        Marker(rec.title, coordinate: CLLocationCoordinate2D(latitude: loc.first!.latitude, longitude: loc.first!.longitude))
                            .tint(.blue)

                    }
                }
                
                ForEach(viewModel.routes, id: \.self) { route in
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 8)
                }
                
                
            } // Map
            .onTapGesture { gestureLocation in
               viewModel.mapView.convert(
                gestureLocation,
                toCoordinateFrom: viewModel.mapView
               )
            }
            
            if let selection {
                if let _ = viewModel.tmpRecomm.first(where: { $0.id == selection }) {
                    SurroundingMapState(pathInfo: $viewModel.selectedRecomm)
                }
                
                if let _ = dbManager.records.first(where: { $0.id == selection.uuidString }) {
                    SurroundingMapState(pathInfo: $viewModel.selectedRecomm)
                }
            } // if let selection
        } // ZStack
        
        .onChange(of: selection) { selec in
            if selec == nil {
                viewModel.clearRoutes()
            } else {
                guard let item = viewModel.tmpRecomm.first(where: { $0.id == selec }) else { return }
                viewModel.findPathHaveId(id: item.id)
            }
        } // onChange
//        
//        .onChange(of: dbManager.records) { recordArr in
//            viewModel.addFromDB(records: recordArr)
//        }
        
        .onAppear {
        
            dbManager.startListening()
            
            viewModel.requestLocationManager()
        }
        
        .onDisappear {
            dbManager.stopListening()

        }
    
    } // body
}

// MARK: CLLocationCoordinate2D
extension CLLocationCoordinate2D {
    static let gongneungStation = CLLocationCoordinate2D(latitude: 37.625797, longitude: 127.072940)
    
    static let starbucks = CLLocationCoordinate2D(latitude: 37.626423, longitude: 127.072252)
    
    static let samsungServiceCenter = CLLocationCoordinate2D(latitude: 37.627525, longitude: 127.072381)
    
    static let universityofTechn = CLLocationCoordinate2D(latitude: 37.631905, longitude: 127.077548)
    
    static let tmpRoadStartPoints = CLLocationCoordinate2D(latitude: 37.630804, longitude: 127.064472)
    
    static let tmpRoadEndPoints = CLLocationCoordinate2D(latitude: 37.620096, longitude: 127.081564)
    
    static let eleSchool = CLLocationCoordinate2D(latitude: 37.626951, longitude: 127.074341)
    
    static let hahaha = CLLocationCoordinate2D(latitude: 37.629992, longitude: 127.078091)
    
    static let wpart = CLLocationCoordinate2D(latitude: 37.622875, longitude: 127.069274)
}

#Preview {
    SurroundingMapView()
        .environmentObject(RecordStore.shared)
}
