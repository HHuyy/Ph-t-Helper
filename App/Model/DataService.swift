//
//  DataService.swift
//  App
//
//  Created by Đừng xóa on 9/22/18.
//  Copyright © 2018 Đừng xóa. All rights reserved.
//

import Foundation

class DataService {
    static let shared: DataService = DataService()
    var test: [DICT]?
    
    private var _my4mien: [PlaceViewNam]?
    var my4mien: [PlaceViewNam] {
        get {
            getDataMien()
            return _my4mien ?? []
        }
        set {
            _my4mien = newValue
        }
    }
    
    func getDataMien() {
        _my4mien = []
        for dataMien in test! {
            if let place = PlaceViewNam(dictionary: dataMien) {
                _my4mien?.append(place)
            }
        }
    }
    
    func getDataPlist(place: String) {
        guard let filePath = Bundle.main.path(forResource: "PlacesVietnam", ofType: "plist") else {return}
        guard FileManager.default.fileExists(atPath: filePath) else {return}
        guard let data = FileManager.default.contents(atPath: filePath) else {return}
        do {
            guard let root = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? DICT else { return }
            guard let mien = root[place] as? [DICT] else { return }
            test = mien
        } catch {
            print("PropertyListSerialization Error")
        }
    }
}
