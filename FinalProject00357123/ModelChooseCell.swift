//
//  ModelChooseCell.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/12.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import UIKit

class ModelChooseCell: UITableViewCell {

    static var imgdata : [UIImage] = [#imageLiteral(resourceName: "head") , #imageLiteral(resourceName: "aqua"), #imageLiteral(resourceName: "emilla"), #imageLiteral(resourceName: "kanna"), #imageLiteral(resourceName: "miitei"), #imageLiteral(resourceName: "nanachi"), #imageLiteral(resourceName: "regu"), #imageLiteral(resourceName: "riko"), #imageLiteral(resourceName: "tohru") ]
    
    static func getImage (_ name : String) -> UIImage{
        switch name {
        case "tohru":
            return #imageLiteral(resourceName: "tohru")
        case "kanna":
            return #imageLiteral(resourceName: "kanna")
        case "emilia":
            return #imageLiteral(resourceName: "emilla")
        case "Regu":
            return #imageLiteral(resourceName: "regu")
        case "aqua":
            return #imageLiteral(resourceName: "aqua")
        case "miitei":
            return #imageLiteral(resourceName: "miitei")
        case "Riko":
            return #imageLiteral(resourceName: "riko")
        case "Nanachi":
            return #imageLiteral(resourceName: "nanachi")
        default:
            return #imageLiteral(resourceName: "head")
        }
    }
    static func getDesName (_ name : String) -> String{
        switch name {
        case "tohru":
            return "朵露"
        case "kanna":
            return "康娜"
        case "emilia":
            return "艾蜜莉雅"
        case "Regu":
            return "雷格"
        case "aqua":
            return "阿克亞"
        case "miitei":
            return "米蒂"
        case "Riko":
            return "莉可"
        case "Nanachi":
            return "娜娜奇"
        default:
            return "N/A"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
