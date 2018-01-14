//
//  GobalSetting.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/15.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation
import UIKit

struct GobalSetting: Codable {
    var selectid: Int
    
    init() {
        selectid = -1
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveToFile(settings: GobalSetting) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(settings) {
            let url = Charactor.documentsDirectory.appendingPathComponent("gobalSetting")
            try? data.write(to: url)
        }
    }
    
    static func readFromFile() -> GobalSetting? {
        let propertyDecoder = PropertyListDecoder()
        let url = Charactor.documentsDirectory.appendingPathComponent("gobalSetting")
        if let data = try? Data(contentsOf: url), let lovers = try? propertyDecoder.decode(GobalSetting.self, from: data) {
            return lovers
        } else {
            return nil
        }
    }
    
}
