//
//  CharactorTableViewCell.swift
//  FinalProject00357123
//
//  Created by 張宇帆 on 2018/1/10.
//  Copyright © 2018年 NTOU department of computer science. All rights reserved.
//

import UIKit

class CharactorTableViewCell: UITableViewCell {

    @IBOutlet weak var MyImages: UIImageView!
    @IBOutlet weak var MyModelImages: UIImageView!
    @IBOutlet weak var MyModelNames: UILabel!
    @IBOutlet weak var MyCharactorNames: UILabel!
    @IBOutlet weak var MyCharactorsDescribes: UILabel!
    @IBOutlet weak var IfHasWikis: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
