//
//  ModelLocation.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/7.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation

struct ModelLocation {
    var x : Float
    var y : Float
    var scx : Float
    var scy : Float
    init(x xpos : Float, y ypos : Float, scx sc_x : Float, scy sc_y : Float){
        x = xpos
        y = ypos
        scx = sc_x
        scy = sc_y
    }
}
