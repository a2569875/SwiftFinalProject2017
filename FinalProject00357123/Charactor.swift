//
//  Charactor.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/10.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation
import UIKit

struct Charactor: Codable {
    var name: String
    var orgName: String
    var innerBeauty: Bool
    var imageName: String?
    var modelName: String?
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func saveToFile(lovers: [Charactor]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(lovers) {
            let url = Charactor.documentsDirectory.appendingPathComponent("charactor")
            try? data.write(to: url)
        }
    }
    
    static func readFromFile() -> [Charactor]? {
        let propertyDecoder = PropertyListDecoder()
        let url = Charactor.documentsDirectory.appendingPathComponent("charactor")
        if let data = try? Data(contentsOf: url), let lovers = try? propertyDecoder.decode([Charactor].self, from: data) {
            return lovers
        } else {
            return nil
        }
    }
    
    var image: UIImage? {
        if let imageName = imageName {
            let url = Charactor.documentsDirectory.appendingPathComponent(imageName)
            return UIImage(contentsOfFile: url.path)
        } else {
            return #imageLiteral(resourceName: "head")
        }
    }
    
    var image_image: UIImage? {
        if let imageName = imageName {
            let url = Charactor.documentsDirectory.appendingPathComponent(imageName)
            return UIImage(contentsOfFile: url.path)
        } else {
            return nil
        }
    }
    
    var image_name : String? {
        if let imageName = imageName {
            return imageName
        } else {
            return nil
        }
    }
}
