//
//  Live2DTargetPointObj.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/15.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation
import UIKit

class Live2DTargetPointObj{
    var live2DModel: Live2DTargetPoint!
    init() {
        live2DModel = Live2DTargetPoint()
    }
    
    func set(x:Float, y:Float){
        self.live2DModel.setXY(x, y: y)
    }
    
    func get() -> CGPoint{
        return CGPoint(x: CGFloat(self.live2DModel.getX()), y: CGFloat(self.live2DModel.getY()))
    }
    
    func update(){
        self.live2DModel.update()
    }
}
