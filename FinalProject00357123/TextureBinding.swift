//
//  TextureBinding.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/16.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation
import UIKit

class TextureSwift {
    static func getTextureId(_ image : UIImage ,img_name: String) -> GLuint {
        return TextureObjC.uiImage(toTexture: image, name: img_name)
    }
}
