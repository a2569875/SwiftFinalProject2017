//
//  Live2DPhysicsObj.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/15.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation
import UIKit

class Live2DPhysicsObj{
    var live2DPhy: Live2DPhysicsObjC!
    init(phyPath : String) {
        live2DPhy = Live2DPhysicsObjC(modelPath: phyPath)
    }
    
    func update(model : Live2DModelOpenGL) {
        live2DPhy.update(model)
    }
    
}
