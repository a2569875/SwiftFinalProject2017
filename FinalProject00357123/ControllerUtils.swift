//
//  ControllerUtils.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/15.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import Foundation
import UIKit

class ControllerUtil {
    
    static func showAlert(_ this_self : UIViewController ,message: String) {
        let controller = UIAlertController(title: "錯誤", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        controller.addAction(action)
        this_self.present(controller, animated: true, completion: nil)
        
    }
    
}
