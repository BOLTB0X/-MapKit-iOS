//
//  MarkerSelectionView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/14/24.
//

import SwiftUI
import MapKit

// MARK: - 
struct MarkerSelectionView: View {
    @State private var selectedTag: Int?
    
    var body: some View {
        Map(selection: $selectedTag) {
            Marker("공릉", coordinate: .gongneungStation)
                .tint(.orange)
                .tag(1)
            
            Annotation("과기대", coordinate: .universityofTechn) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(selectedTag == 2 ? .red : .cyan)
                    Text("🎓")
                        .padding(5)
                }
            }
            .tag(2)
        }
    }
}

#Preview {
    MarkerSelectionView()
}
