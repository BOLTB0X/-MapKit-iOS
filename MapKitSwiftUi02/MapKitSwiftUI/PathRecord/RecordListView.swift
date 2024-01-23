//
//  RecordListView.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/23/24.
//

import SwiftUI

struct RecordListView: View {
    @ObservedObject var dbManager = RecordStore.shared

    var body: some View {
        NavigationView {
            List {
                ForEach(dbManager.records) { record in
                    VStack {
                        Text(record.title)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Record 확인")
        }
        .onAppear {
            print(dbManager.records)
        }
    }
}

//#Preview {
//    RecordListView()
//}
