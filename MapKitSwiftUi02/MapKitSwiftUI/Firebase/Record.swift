//
//  RecordModel.swift
//  MapKitSwiftUI
//
//  Created by lkh on 1/22/24.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift
import MapKit

// MARK: - Record
struct Record: Identifiable, Codable, Hashable {
    let id = UUID().uuidString
    let userLocations: [LocationCoordinate]?
    let title: String
    let currentAddress: String
    let recordingMeter: String
    let recordingTime: String
    
    init() {
        self.userLocations = nil
        self.title = ""
        self.currentAddress = ""
        self.recordingMeter = ""
        self.recordingTime = ""
    }
    
    init(userLocations: [LocationCoordinate], title: String, currentAddress: String, recordingMeter: String, recordingTime: String) {
        self.userLocations = userLocations
        self.title = title
        self.currentAddress = currentAddress
        self.recordingMeter = recordingMeter
        self.recordingTime = recordingTime
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userLocations
        case title
        case currentAddress
        case recordingMeter
        case recordingTime
    }
    
    struct LocationCoordinate: Identifiable, Codable, Hashable {
        let id = UUID().uuidString
        let latitude: Double
        let longitude: Double
        
        init(coordinate: CLLocationCoordinate2D) {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}

// MARK: - RecordStore
class RecordStore: ObservableObject {
    static let shared = RecordStore()
    
    init() { }
    
    // MARK: - 프로퍼티s
    @Published var records: [Record] = []
    
    let ref: DatabaseReference? = Database.database().reference()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Method
    // ...

    // MARK: - startListening
    // 데이터베이스를 실시간으로 관찰하여 데이터 변경 여부를 확인
    // 실시간 데이터 read, write를 가능
    func startListening() {
        guard let dbPath = ref?.child("records") else { return }
        
        // MARK: Create
        dbPath.observe(DataEventType.childAdded) { [weak self] snapshot in
            guard let self = self, let json = snapshot.value as? [String: Any] else {
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let record = try self.decoder.decode(Record.self, from: data)
                if !self.records.contains(where: { $0.id == record.id }) {
                    self.records.append(record)
                }
            } catch {
                print(error)
            }
        }
        
        // MARK: 삭제 관련
        // 데이터 삭제가 감지 되었을 때
        dbPath.observe(DataEventType.childRemoved) { [weak self] snapshot in
            guard let self = self, let json = snapshot.value as? [String: Any] else {
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let record = try self.decoder.decode(Record.self, from: data)
                if let index = self.records.firstIndex(where: { $0.id == record.id }) {
                    self.records.remove(at: index)
                }
            } catch {
                print(error)
            }
        }
        
        // MARK: update, read 관련
        // 데이터 변경이 감지 되었을 때
        dbPath.observe(DataEventType.childChanged) { [weak self] snapshot in
            guard let self = self, let json = snapshot.value as? [String: Any] else {
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: json)
                let record = try self.decoder.decode(Record.self, from: data)
                if let index = self.records.firstIndex(where: { $0.id == record.id }) {
                    self.records[index] = record
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - stopListening
    // 데이터베이스를 실시간으로 관찰하는 것을 중지
    func stopListening() {
        ref?.removeAllObservers()
    }
    
    // MARK: - addRecord
    // 데이터베이스에 Record 인스턴스를 추가
    func addRecord(item: Record) {
        var locationsData: [[String: Double]] = []

        if let userLocations = item.userLocations {
            for location in userLocations {
                let coordinateDict: [String: Double] = [
                    "latitude": location.latitude,
                    "longitude": location.longitude
                ]
                locationsData.append(coordinateDict)
            }
        }

        self.ref?.child("records/\(item.id)").setValue([
            "id": item.id,
            "userLocations": locationsData,
            "title": item.title,
            "currentAddress": item.currentAddress,
            "recordingMeter": item.recordingMeter,
            "recordingTime": item.recordingTime
        ])
    }
    // 데이터베이스에서 특정 경로의 데이터를 삭제
    func deleteProduct(key: String) {
        ref?.child("records/\(key)").removeValue()
    }
    
    // MARK: - editProduct
    // 데이터베이스에서 특정 경로의 데이터를 수정
    func editProduct(item: Record) {
        let update: [String : Any] = [
            "id": item.id,
            "userLocations": item.userLocations,
            "title": item.title,
            "currentAddress": item.currentAddress,
            "recordingMeter": item.recordingMeter,
            "recordingTime": item.recordingTime
        ]
        
        self.ref?.child("records/\(item.id)").setValue(update)
        
        if let index = self.records.firstIndex(where: { $0.id == item.id }) {
            self.records[index] = item
        }
    }
}
